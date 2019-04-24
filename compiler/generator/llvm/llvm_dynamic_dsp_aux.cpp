/************************************************************************
 ************************************************************************
    FAUST compiler
    Copyright (C) 2003-2018 GRAME, Centre National de Creation Musicale
    ---------------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 ************************************************************************
 ************************************************************************/
#ifdef WIN32
# pragma warning (disable: 4141 4244 4291 4146 4267 4275 4624 4800)
#endif
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <list>
#include <sstream>
#include "Text.hh"
#include "compatibility.hh"
#include "global.hh"
#include "libfaust.h"
#include "llvm_dynamic_dsp_aux.hh"
#include "rn_base64.h"
#include <llvm-c/Core.h>
#include <llvm/ADT/Triple.h>
#include <llvm/ExecutionEngine/MCJIT.h>
#include <llvm/ExecutionEngine/ObjectCache.h>
#include <llvm/IR/DataLayout.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/LegacyPassNameParser.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Linker/Linker.h>
#include <llvm/MC/SubtargetFeature.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/FormattedStream.h>
#include <llvm/Support/Host.h>
#include <llvm/Support/ManagedStatic.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/TargetRegistry.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/Threading.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/Transforms/IPO.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <system_error>
#include "llvm/ExecutionEngine/ObjectCache.h"
#ifndef LLVM_35
#include <llvm/Analysis/TargetLibraryInfo.h>
#include <llvm/Analysis/TargetTransformInfo.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Target/TargetMachine.h>
#else
#include <llvm/Target/TargetLibraryInfo.h>
#endif
#if defined(LLVM_40) || defined(LLVM_50) || defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
#include <llvm/Bitcode/BitcodeReader.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Transforms/IPO/AlwaysInliner.h>
#elif defined(LLVM_35) || defined(LLVM_38) || defined(LLVM_39)
#include <llvm/Bitcode/ReaderWriter.h>
#include <llvm/Support/raw_ostream.h>
#endif
using namespace llvm;
using namespace std;
#define dumpLLVM(val)                            \
    {                                            \
        string             res;                  \
        raw_string_ostream out_str(res);         \
        out_str << *val;                         \
        std::cout << out_str.str() << std::endl; \
    }
static void splitTarget(const string& target, string& triple, string& cpu)
{
    size_t pos1 = target.find_first_of(':');
    triple      = target.substr(0, pos1);
    if (pos1 != string::npos) {
        cpu = target.substr(pos1 + 1);
    }
}
static string getParam(int argc, const char* argv[], const string& param, const string& def)
{
    for (int i = 0; i < argc; i++) {
        if (string(argv[i]) == param) return argv[i + 1];
    }
    return def;
}
#if defined(LLVM_40) || defined(LLVM_50) || defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
static Module* ParseBitcodeFile(MEMORY_BUFFER Buffer, LLVMContext& Context, string* ErrMsg)
{
    using namespace llvm;
    Expected<std::unique_ptr<Module>> ModuleOrErr = parseBitcodeFile(Buffer, Context);
    if (!ModuleOrErr) {
        if (ErrMsg) *ErrMsg = "Failed to read bitcode";
        return nullptr;
    } else {
        return ModuleOrErr.get().release();
    }
}
#elif defined(LLVM_38) || defined(LLVM_39)
static Module* ParseBitcodeFile(MEMORY_BUFFER Buffer, LLVMContext& Context, string* ErrMsg)
{
    using namespace llvm;
    ErrorOr<unique_ptr<Module>> ModuleOrErr = parseBitcodeFile(Buffer, Context);
    if (error_code EC = ModuleOrErr.getError()) {
        if (ErrMsg) *ErrMsg = EC.message();
        return nullptr;
    } else {
        return ModuleOrErr.get().release();
    }
}
#elif defined(LLVM_35)
// LLVM 3.5 has parseBitcodeFile(). Must emulate ParseBitcodeFile. -ag
static Module* ParseBitcodeFile(MEMORY_BUFFER Buffer, LLVMContext& Context, string* ErrMsg)
{
    using namespace llvm;
    ErrorOr<Module*> ModuleOrErr = parseBitcodeFile(Buffer, Context);
    if (error_code EC = ModuleOrErr.getError()) {
        if (ErrMsg) *ErrMsg = EC.message();
        return nullptr;
    } else {
        return ModuleOrErr.get();
    }
}
#endif
void llvm_dynamic_dsp_factory_aux::write(std::ostream* out, bool binary, bool small)
{
    string             res;
    raw_string_ostream out_str(res);
    if (binary) {
#if defined(LLVM_70) || defined(LLVM_80)
        WriteBitcodeToFile(*fModule, out_str);
#else
        WriteBitcodeToFile(fModule, out_str);
#endif
    } else {
        out_str << *fModule;
    }
    *out << out_str.str();
}
// Bitcode
string llvm_dynamic_dsp_factory_aux::writeDSPFactoryToBitcode()
{
    string             res;
    raw_string_ostream out(res);
#if defined(LLVM_70) || defined(LLVM_80)
    WriteBitcodeToFile(*fModule, out);
#else
    WriteBitcodeToFile(fModule, out);
#endif
    out.flush();
    return base64_encode(res);
}
void llvm_dynamic_dsp_factory_aux::writeDSPFactoryToBitcodeFile(const string& bit_code_path)
{
    STREAM_ERROR   err;
    raw_fd_ostream out(bit_code_path.c_str(), err, sysfs_binary_flag);
#if defined(LLVM_70) || defined(LLVM_80)
    WriteBitcodeToFile(*fModule, out);
#else
    WriteBitcodeToFile(fModule, out);
#endif
}
// IR
string llvm_dynamic_dsp_factory_aux::writeDSPFactoryToIR()
{
    string             res;
    raw_string_ostream out(res);
    PASS_MANAGER       PM;
    PM.add(llvmcreatePrintModulePass(out));
    PM.run(*fModule);
    out.flush();
    return res;
}
void llvm_dynamic_dsp_factory_aux::writeDSPFactoryToIRFile(const string& ir_code_path)
{
    STREAM_ERROR   err;
    raw_fd_ostream out(ir_code_path.c_str(), err, sysfs_binary_flag);
    PASS_MANAGER   PM;
    PM.add(llvmcreatePrintModulePass(out));
    PM.run(*fModule);
    out.flush();
}
/// AddOptimizationPasses - This routine adds optimization passes
/// based on selected optimization level, OptLevel. This routine
/// duplicates llvm-gcc behaviour.
///
/// OptLevel - Optimization Level
static void AddOptimizationPasses(PassManagerBase& MPM, FUNCTION_PASS_MANAGER& FPM, unsigned OptLevel,
                                unsigned SizeLevel)
{
    FPM.add(createVerifierPass());  // Verify that input is correct
    PassManagerBuilder Builder;
    Builder.OptLevel  = OptLevel;
    Builder.SizeLevel = SizeLevel;
    if (OptLevel > 1) {
        unsigned Threshold = 225;
        if (SizeLevel == 1) {  // -Os
            Threshold = 75;
        } else if (SizeLevel == 2) {  // -Oz
            Threshold = 25;
        }
        if (OptLevel > 2) {
            Threshold = 275;
        }
        Builder.Inliner = createFunctionInliningPass(Threshold);
    } else {
#if defined(LLVM_40) || defined(LLVM_50) || defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
        Builder.Inliner = createAlwaysInlinerLegacyPass();
#else
        Builder.Inliner = createAlwaysInlinerPass();
#endif
    }
    Builder.DisableUnrollLoops = (OptLevel == 0);
    // Add auto-vectorization passes
    if (OptLevel > 3) {
        Builder.LoopVectorize = true;
        Builder.SLPVectorize  = true;
    }
    Builder.populateFunctionPassManager(FPM);
    Builder.populateModulePassManager(MPM);
}
bool llvm_dynamic_dsp_factory_aux::initJIT(string& error_msg)
{
    startTiming("initJIT");
    faustassert(fModule);
#ifdef LLVM_BUILD_UNIVERSAL
    // For multiple target support
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmPrinters();
    InitializeAllAsmParsers();
#endif
    // For host target support
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();
    InitializeNativeTargetAsmParser();
    // For ObjectCache to work...
    LLVMLinkInMCJIT();
    // Initialize passes
    PassRegistry& Registry = *PassRegistry::getPassRegistry();
    initializeCodeGen(Registry);
    initializeCore(Registry);
    initializeScalarOpts(Registry);
    initializeObjCARCOpts(Registry);
    initializeVectorization(Registry);
    initializeIPO(Registry);
    initializeAnalysis(Registry);
#if defined(LLVM_35)
    initializeIPA(Registry);
#endif
    initializeTransformUtils(Registry);
    initializeInstCombine(Registry);
    initializeInstrumentation(Registry);
    initializeTarget(Registry);
#if defined(LLVM_35)
    EngineBuilder builder(fModule);
#else
    EngineBuilder builder((unique_ptr<Module>(fModule)));
#endif
    builder.setOptLevel(CodeGenOpt::Aggressive);
    builder.setEngineKind(EngineKind::JIT);
#if !defined(LLVM_60) && !defined(LLVM_70) && !defined(LLVM_80)
    builder.setCodeModel(CodeModel::JITDefault);
#endif
    string buider_error;
    builder.setErrorStr(&buider_error);
#if defined(LLVM_35)
    builder.setUseMCJIT(true);
#endif
#if defined(_WIN32) && defined(LLVM_35)
    // Windows needs this special suffix to the target triple,
    // otherwise the backend would try to generate native COFF
    // code which the JIT can't use
    // (cf. http://lists.cs.uiuc.edu/pipermail/llvmdev/2013-December/068407.html).
    string target_suffix = "-elf";
#else
    string target_suffix = "";
#endif
    string triple, cpu;
    splitTarget(fTarget, triple, cpu);
    fModule->setTargetTriple(triple + target_suffix);
    builder.setMCPU((cpu == "") ? llvm::sys::getHostCPUName() : StringRef(cpu));
    TargetOptions targetOptions;
    // -fastmath is activated at IR level, and has to be setup at JIT level also
#if !defined(LLVM_50) && !defined(LLVM_60) && !defined(LLVM_70) && !defined(LLVM_80)
    targetOptions.LessPreciseFPMADOption = true;
#endif
    targetOptions.AllowFPOpFusion       = FPOpFusion::Fast;
    targetOptions.UnsafeFPMath          = true;
    targetOptions.NoInfsFPMath          = true;
    targetOptions.NoNaNsFPMath          = true;
    targetOptions.GuaranteedTailCallOpt = true;
#if defined(LLVM_40) || defined(LLVM_50) || defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
    targetOptions.NoTrappingFPMath = true;
    targetOptions.FPDenormalMode   = FPDenormal::IEEE;
#endif
    targetOptions.GuaranteedTailCallOpt = true;
    string debug_var                    = (getenv("FAUST_DEBUG")) ? string(getenv("FAUST_DEBUG")) : "";
    if ((debug_var != "") && (debug_var.find("FAUST_LLVM3") != string::npos)) {
        targetOptions.PrintMachineCode = true;
    }
    builder.setTargetOptions(targetOptions);
    TargetMachine* tm = builder.selectTarget();
    fJIT = builder.create(tm);
    if (!fJIT) {
        endTiming("initJIT");
        error_msg = "ERROR : cannot create LLVM JIT : " + buider_error;
        return false;
    }
    int optlevel = getOptlevel();
    if ((optlevel == -1) || (fOptLevel > optlevel)) {
        PASS_MANAGER          pm;
        FUNCTION_PASS_MANAGER fpm(fModule);
        // Code taken from opt.cpp
#if defined(LLVM_35)
        // Add an appropriate TargetLibraryInfo pass for the module's triple.
        TargetLibraryInfo* tli = new TargetLibraryInfo(Triple(fModule->getTargetTriple()));
        pm.add(tli);
#else
        TargetLibraryInfoImpl TLII(Triple(fModule->getTargetTriple()));
        pm.add(new TargetLibraryInfoWrapperPass(TLII));
#endif
        fModule->setDataLayout(fJIT->getDataLayout());
        // Add internal analysis passes from the target machine (mandatory for vectorization to work)
        // Code taken from opt.cpp
#if defined(LLVM_35)
        tm->addAnalysisPasses(pm);
#else
        pm.add(createTargetTransformInfoWrapperPass(tm->getTargetIRAnalysis()));
#endif
        if (fOptLevel > 0) {
            AddOptimizationPasses(pm, fpm, fOptLevel, 0);
        }
        if ((debug_var != "") && (debug_var.find("FAUST_LLVM1") != string::npos)) {
#if defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
        // TargetRegistry::printRegisteredTargetsForVersion(std::cout);
#else
            TargetRegistry::printRegisteredTargetsForVersion();
#endif
            dumpLLVM(fModule);
        }
        fpm.doInitialization();
        for (Module::iterator F = fModule->begin(), E = fModule->end(); F != E; ++F) {
            fpm.run(*F);
        }
        fpm.doFinalization();
        pm.add(createVerifierPass());
        if ((debug_var != "") && (debug_var.find("FAUST_LLVM4") != string::npos)) {
#if defined(LLVM_38) || defined(LLVM_39) || defined(LLVM_40) || defined(LLVM_50) || defined(LLVM_60) || defined(LLVM_70) || defined(LLVM_80)
        // TODO
#else
            tm->addPassesToEmitFile(pm, fouts(), TargetMachine::CGFT_AssemblyFile, true);
#endif
        }
        // Now that we have all of the passes ready, run them.
        pm.run(*fModule);
        if ((debug_var != "") && (debug_var.find("FAUST_LLVM2") != string::npos)) {
            dumpLLVM(fModule);
        }
    }
#ifndef LLVM_35
    fObjectCache = new FaustObjectCache();
    fJIT->setObjectCache(fObjectCache);
#endif
    return initJITAux(error_msg);
}
// Public C++ API
EXPORT llvm_dsp_factory* createDSPFactoryFromFile(const string& filename, int argc, const char* argv[],
                                                const string& target, string& error_msg, int opt_level)
{
    string base = basename((char*)filename.c_str());
    size_t pos  = filename.find(".dsp");
    if (pos != string::npos) {
        return createDSPFactoryFromString(base.substr(0, pos), pathToContent(filename), argc, argv, target, error_msg,
                                        opt_level);
    } else {
        error_msg = "ERROR : file Extension is not the one expected (.dsp expected)\n";
        return nullptr;
    }
}
EXPORT llvm_dsp_factory* createDSPFactoryFromString(const string& name_app, const string& dsp_content, int argc,
                                                    const char* argv[], const string& target, string& error_msg,
                                                    int opt_level)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    string expanded_dsp_content, sha_key;
    if ((expanded_dsp_content = expandDSPFromString(name_app, dsp_content, argc, argv, sha_key, error_msg)) == "") {
        return nullptr;
    } else {
        int         argc1 = 0;
        const char* argv1[64];
        argv1[argc1++] = "faust";
        argv1[argc1++] = "-lang";
        // argv1[2] = "cllvm";
        argv1[argc1++] = "llvm";
        argv1[argc1++] = "-o";
        argv1[argc1++] = "string";
        // Filter arguments
        for (int i = 0; i < argc; i++) {
            if (!(strcmp(argv[i], "-tg") == 0 || strcmp(argv[i], "-sg") == 0 || strcmp(argv[i], "-ps") == 0 ||
                strcmp(argv[i], "-svg") == 0 || strcmp(argv[i], "-mdoc") == 0 || strcmp(argv[i], "-mdlang") == 0 ||
                strcmp(argv[i], "-stripdoc") == 0 || strcmp(argv[i], "-sd") == 0 || strcmp(argv[i], "-xml") == 0 ||
                strcmp(argv[i], "-json") == 0)) {
                argv1[argc1++] = argv[i];
            }
        }
        argv1[argc1] = 0;  // NULL terminated argv
        dsp_factory_table<SDsp_factory>::factory_iterator it;
        llvm_dsp_factory*                                 factory = 0;
        if (llvm_dsp_factory_aux::gLLVMFactoryTable.getFactory(sha_key, it)) {
            SDsp_factory sfactory = (*it).first;
            sfactory->addReference();
            return sfactory;
        } else {
            llvm_dynamic_dsp_factory_aux* factory_aux = nullptr;
            try {
                factory_aux = static_cast<llvm_dynamic_dsp_factory_aux*>(
                    compileFaustFactory(argc1, argv1, name_app.c_str(), dsp_content.c_str(), error_msg, true));
                if (factory_aux) {
                    factory_aux->setTarget(target);
                    factory_aux->setOptlevel(opt_level);
                    factory_aux->setClassName(getParam(argc, argv, "-cn", "mydsp"));
                    factory_aux->setName(name_app);
                    if (!factory_aux->initJIT(error_msg)) {
                        goto error;
                    }
                    factory = new llvm_dsp_factory(factory_aux);
                    llvm_dsp_factory_aux::gLLVMFactoryTable.setFactory(factory);
                    factory->setSHAKey(sha_key);
                    factory->setDSPCode(expanded_dsp_content);
                    return factory;
                }
            } catch (faustexception& e) {
                error_msg = e.what();
                goto error;
            }
        error:
            delete factory_aux;
            return nullptr;
        }
    }
}
// Bitcode <==> string
static llvm_dsp_factory* readDSPFactoryFromBitcodeAux(MEMORY_BUFFER buffer, const string& target, string& error_msg, int opt_level)
{
    string sha_key = generateSHA1(MEMORY_BUFFER_GET(buffer).str());
    dsp_factory_table<SDsp_factory>::factory_iterator it;
    if (llvm_dsp_factory_aux::gLLVMFactoryTable.getFactory(sha_key, it)) {
        SDsp_factory sfactory = (*it).first;
        sfactory->addReference();
        return sfactory;
    } else {
        string       error_msg;
        LLVMContext* context = new LLVMContext();
        Module*      module  = ParseBitcodeFile(buffer, *context, &error_msg);
        if (!module) return nullptr;
        llvm_dynamic_dsp_factory_aux* factory_aux =
            new llvm_dynamic_dsp_factory_aux(sha_key, module, context, target, opt_level);
        if (factory_aux->initJIT(error_msg)) {
            llvm_dsp_factory* factory = new llvm_dsp_factory(factory_aux);
            llvm_dsp_factory_aux::gLLVMFactoryTable.setFactory(factory);
            factory->setSHAKey(sha_key);
            return factory;
        } else {
            error_msg = "ERROR : readDSPFactoryFromBitcode failed : " + error_msg;
            delete factory_aux;
            return nullptr;
        }
    }
}
EXPORT llvm_dsp_factory* readDSPFactoryFromBitcode(const string& bit_code, const string& target, string& error_msg, int opt_level)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    return readDSPFactoryFromBitcodeAux(MEMORY_BUFFER_CREATE(StringRef(base64_decode(bit_code))), target, error_msg, opt_level);
}
EXPORT string writeDSPFactoryToBitcode(llvm_dsp_factory* factory)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    return (factory) ? factory->writeDSPFactoryToBitcode() : "";
}
// Bitcode <==> file
EXPORT llvm_dsp_factory* readDSPFactoryFromBitcodeFile(const string& bit_code_path, const string& target, string& error_msg, int opt_level)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    ErrorOr<OwningPtr<MemoryBuffer>> buffer = MemoryBuffer::getFileOrSTDIN(bit_code_path);
    if (error_code ec = buffer.getError()) {
        error_msg = "ERROR : readDSPFactoryFromBitcodeFile failed : " + ec.message() + "\n";
        return nullptr;
    } else {
        return readDSPFactoryFromBitcodeAux(MEMORY_BUFFER_GET_REF(buffer), target, error_msg, opt_level);
    }
}
EXPORT void writeDSPFactoryToBitcodeFile(llvm_dsp_factory* factory, const string& bit_code_path)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    if (factory) {
        factory->writeDSPFactoryToBitcodeFile(bit_code_path);
    }
}
// IR <==> string
static llvm_dsp_factory* readDSPFactoryFromIRAux(MEMORY_BUFFER buffer, const string& target, string& error_msg, int opt_level)
{
    string sha_key = generateSHA1(MEMORY_BUFFER_GET(buffer).str());
    dsp_factory_table<SDsp_factory>::factory_iterator it;
    if (llvm_dsp_factory_aux::gLLVMFactoryTable.getFactory(sha_key, it)) {
        SDsp_factory sfactory = (*it).first;
        sfactory->addReference();
        return sfactory;
    } else {
        char* tmp_local = setlocale(LC_ALL, NULL);
        setlocale(LC_ALL, "C");
        LLVMContext* context = new LLVMContext();
        SMDiagnostic err;
#if defined(LLVM_35)
        // ParseIR takes ownership of the given buffer, so don't delete it
        Module* module = ParseIR(buffer, err, *context);
#else
        // parseIR takes ownership of the given buffer, so don't delete it
        Module* module = parseIR(buffer, err, *context).release();
#endif
        if (!module) return nullptr;
        setlocale(LC_ALL, tmp_local);
        string error_msg;
        llvm_dynamic_dsp_factory_aux* factory_aux =
            new llvm_dynamic_dsp_factory_aux(sha_key, module, context, target, opt_level);
        if (factory_aux->initJIT(error_msg)) {
            llvm_dsp_factory* factory = new llvm_dsp_factory(factory_aux);
            llvm_dsp_factory_aux::gLLVMFactoryTable.setFactory(factory);
            factory->setSHAKey(sha_key);
            return factory;
        } else {
            error_msg = "ERROR : readDSPFactoryFromBitcode failed : " + error_msg;
            delete factory_aux;
            return nullptr;
        }
    }
}
EXPORT llvm_dsp_factory* readDSPFactoryFromIR(const string& ir_code, const string& target, string& error_msg, int opt_level)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    return readDSPFactoryFromIRAux(MEMORY_BUFFER_CREATE(StringRef(ir_code)), target, error_msg, opt_level);
}
EXPORT string writeDSPFactoryToIR(llvm_dsp_factory* factory)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    return (factory) ? factory->writeDSPFactoryToIR() : "";
}
// IR <==> file
EXPORT llvm_dsp_factory* readDSPFactoryFromIRFile(const string& ir_code_path, const string& target, string& error_msg, int opt_level)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    ErrorOr<OwningPtr<MemoryBuffer>> buffer = MemoryBuffer::getFileOrSTDIN(ir_code_path);
    if (error_code ec = buffer.getError()) {
        error_msg = "ERROR : readDSPFactoryFromIRFile failed : " + ec.message() + "\n";
        return nullptr;
    } else {
        return readDSPFactoryFromIRAux(MEMORY_BUFFER_GET_REF(buffer), target, error_msg, opt_level);
    }
}
EXPORT void writeDSPFactoryToIRFile(llvm_dsp_factory* factory, const string& ir_code_path)
{
    TLock lock(llvm_dsp_factory_aux::gDSPFactoriesLock);
    if (factory) {
        factory->writeDSPFactoryToIRFile(ir_code_path);
    }
}
// Helper functions
ModulePTR loadSingleModule(const string filename, LLVMContext* context)
{
    SMDiagnostic err;
#if defined(LLVM_35)
    Module* module = ParseIRFile(filename, err, *context);
#else
    ModulePTR module = parseIRFile(filename, err, *context);
#endif
    return module;
}
ModulePTR loadModule(const string& module_name, llvm::LLVMContext* context)
{
    // Try as a complete path
    if (ModulePTR module = loadSingleModule(module_name, context)) {
        return module;
    } else {
        // Otherwise use import directories
        for (size_t i = 0; i < gGlobal->gImportDirList.size(); i++) {
            string file_name = gGlobal->gImportDirList[i] + '/' + module_name;
            if (ModulePTR module = loadSingleModule(file_name, context)) {
                return module;
            }
        }
        return nullptr;
    }
}
bool linkModules(Module* dst, ModulePTR src, char* error_msg)
{
    bool res = false;
#if defined(LLVM_35)
    string err;
    if (Linker::LinkModules(dst, src, Linker::DestroySource, &err)) {
        snprintf(error_msg, 256, "cannot link module : %s", err.c_str());
#else
    if (Linker::linkModules(*dst, MovePTR(src))) {
        snprintf(error_msg, 256, "%s", "cannot link module");
#endif
    } else {
        res = true;
    }
    return res;
}
Module* linkAllModules(llvm::LLVMContext* context, Module* dst, char* error)
{
    for (size_t i = 0; i < gGlobal->gLibraryList.size(); i++) {
        string    module_name = gGlobal->gLibraryList[i];
        ModulePTR src         = loadModule(module_name, context);
        if (!src) {
            sprintf(error, "cannot load module : %s", module_name.c_str());
            return nullptr;
        }
        if (!linkModules(dst, MovePTR(src), error)) {
            return nullptr;
        }
    }
    return dst;
}
    // Public C interface : lock management is done by called C++ API
#ifdef __cplusplus
extern "C" {
#endif
EXPORT llvm_dsp_factory* createCDSPFactoryFromFile(const char* filename, int argc, const char* argv[],
                                                const char* target, char* error_msg, int opt_level)
{
    string            error_msg_aux;
    llvm_dsp_factory* factory = createDSPFactoryFromFile(filename, argc, argv, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT llvm_dsp_factory* createCDSPFactoryFromString(const char* name_app, const char* dsp_content, int argc,
                                                    const char* argv[], const char* target, char* error_msg,
                                                    int opt_level)
{
    string            error_msg_aux;
    llvm_dsp_factory* factory =
        createDSPFactoryFromString(name_app, dsp_content, argc, argv, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT llvm_dsp_factory* readCDSPFactoryFromBitcode(const char* bit_code, const char* target, char* error_msg, int opt_level)
{
    string error_msg_aux;
    llvm_dsp_factory* factory = readDSPFactoryFromBitcode(bit_code, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT char* writeCDSPFactoryToBitcode(llvm_dsp_factory* factory)
{
    return (factory) ? strdup(writeDSPFactoryToBitcode(factory).c_str()) : nullptr;
}
EXPORT llvm_dsp_factory* readCDSPFactoryFromBitcodeFile(const char* bit_code_path, const char* target, char* error_msg, int opt_level)
{
    string error_msg_aux;
    llvm_dsp_factory* factory = readDSPFactoryFromBitcodeFile(bit_code_path, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT void writeCDSPFactoryToBitcodeFile(llvm_dsp_factory* factory, const char* bit_code_path)
{
    if (factory) {
        writeDSPFactoryToBitcodeFile(factory, bit_code_path);
    }
}
EXPORT llvm_dsp_factory* readCDSPFactoryFromIR(const char* ir_code, const char* target, char* error_msg, int opt_level)
{
    string error_msg_aux;
    llvm_dsp_factory* factory = readDSPFactoryFromIR(ir_code, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT char* writeCDSPFactoryToIR(llvm_dsp_factory* factory)
{
    return (factory) ? strdup(writeDSPFactoryToIR(factory).c_str()) : nullptr;
}
EXPORT llvm_dsp_factory* readCDSPFactoryFromIRFile(const char* ir_code_path, const char* target, char* error_msg, int opt_level)
{
    string error_msg_aux;
    llvm_dsp_factory* factory = readDSPFactoryFromIRFile(ir_code_path, target, error_msg_aux, opt_level);
    strncpy(error_msg, error_msg_aux.c_str(), 4096);
    return factory;
}
EXPORT void writeCDSPFactoryToIRFile(llvm_dsp_factory* factory, const char* ir_code_path)
{
    if (factory) {
        writeDSPFactoryToIRFile(factory, ir_code_path);
    }
}
#ifdef __cplusplus
}
#endif
