/************************************************************************
    FAUST Architecture File
    Copyright (C) 2016 GRAME, Centre National de Creation Musicale
    ---------------------------------------------------------------------
    This Architecture section is free software; you can redistribute it
    and/or modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 3 of
    the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; If not, see <http://www.gnu.org/licenses/>.

    EXCEPTION : As a special exception, you may create a larger work
    that contains this FAUST architecture section and distribute
    that work under terms of your choice, so long as this FAUST
    architecture section is not modified.

 ************************************************************************/

#include <libgen.h>
#include <iostream>
#include <fstream>
#include <sstream>

#include "faust/audio/jack-dsp.h"
#include "faust/dsp/interpreter-machine-dsp.h"

#include "faust/dsp/dsp-adapter.h"
#include "faust/dsp/proxy-dsp.h"
#include "faust/dsp/poly-dsp.h"

#include "faust/gui/meta.h"
#include "faust/gui/FUI.h"
#include "faust/gui/faustgtk.h"
#include "faust/gui/MidiUI.h"
#include "faust/gui/httpdUI.h"
#include "faust/gui/OSCUI.h"

#include "faust/misc.h"

using namespace std;

list<GUI*> GUI::fGuiList;
ztimedmap GUI::gTimedZoneMap;

struct malloc_memory_manager : public dsp_memory_manager {
    
    void* allocate(size_t size)
    {
        void* res = malloc(size);
        //cout << "malloc_manager : " << size << " " << res << endl;
        return res;
    }
    virtual void destroy(void* ptr)
    {
        //cout << "free_manager : " << ptr << endl;
        free(ptr);
    }
    
};

int main(int argc, char* argv[])
{
    char name[256];
    char filename[256];
    char rcfilename[256];
    char* home = getenv("HOME");
    
    snprintf(name, 255, "%s", basename(argv[0]));
    snprintf(filename, 255, "%s", basename(argv[argc-1]));
    snprintf(rcfilename, 255, "%s/.%s-%src", home, name, filename);
    
    bool is_midi = isopt(argv, "-midi");
    bool is_osc = isopt(argv, "-osc");
    bool is_httpd = isopt(argv, "-httpd");
    int nvoices = lopt(argv, "-nvoices", -1);
    
    malloc_memory_manager manager;
    
    if (isopt(argv, "-h") || isopt(argv, "-help")) {
        cout << "dynamic-machine-jack-gtk [-nvoices N] [-midi] [-osc] [-httpd] [additional Faust options (-vec -vs 8...)] foo.fbc" << endl;
        cout << "Use '-nvoices <num>' to produce a polyphonic self-contained DSP with <num> voices, ready to be used with MIDI or OSC\n";
        cout << "Use '-midi' to activate MIDI control\n";
        cout << "Use '-osc' to activate OSC control\n";
        cout << "Use '-httpd' to activate HTTP control\n";
        exit(EXIT_FAILURE);
    }
    
    dsp_factory* factory = nullptr;
    dsp* DSP = nullptr;
    mydsp_poly* dsp_poly = nullptr;
    MidiUI* midiinterface = nullptr;
    httpdUI* httpdinterface = nullptr;
    GUI* oscinterface = nullptr;
    jackaudio_midi audio;
    string error_msg;
    
    cout << "Libfaust version : " << getCLibFaustVersion () << endl;
    
    int argc1 = 0;
    const char* argv1[64];
    
    cout << "Compiled with additional options : ";
    for (int i = 1; i < argc-1; i++) {
        if ((string(argv[i]) == "-midi")
            || (string(argv[i]) == "-osc")
            || (string(argv[i]) == "-httpd")) {
            continue;
        } else if (string(argv[i]) == "-nvoices") {
            i++;
            continue;
        }
        argv1[argc1++] = argv[i];
        cout << argv[i] << " ";
    }
    cout << endl;
    
    argv1[argc1] = 0;  // NULL terminated argv
    
    //factory = readDSPFactoryFromMachineFile(argv[1], "");
    factory = readInterpreterDSPFactoryFromBitcodeFile(argv[argc-1], error_msg);
    
    if (!factory) {
        cerr << "Cannot create factory : " << error_msg;
        exit(EXIT_FAILURE);
    }
    
    //factory->setMemoryManager(&manager);  causes crash in -fm mode
    DSP = factory->createDSPInstance();
    if (!DSP) {
        cerr << "Cannot create instance "<< endl;
        exit(EXIT_FAILURE);
    }
    
    cout << "getName " << factory->getName() << endl;
    cout << "getSHAKey " << factory->getSHAKey() << endl;
  
    if (nvoices > 0) {
        cout << "Starting polyphonic mode nvoices : " << nvoices << endl;
        DSP = dsp_poly = new mydsp_poly(DSP, nvoices, true, true);
    }
    
    if (isopt(argv, "-double")) {
        cout << "Running in double..." << endl;
    }
   
    GUI* interface = new GTKUI(filename, &argc, &argv);
    DSP->buildUserInterface(interface);
    
    FUI* finterface = new FUI();
    DSP->buildUserInterface(finterface);
   
    if (!audio.init(filename, DSP)) {
        return 0;
    }

    // After audio.init that calls 'init'
    finterface->recallState(rcfilename);
    
    if (is_httpd) {
        httpdinterface = new httpdUI(name, DSP->getNumInputs(), DSP->getNumOutputs(), argc, argv);
        DSP->buildUserInterface(httpdinterface);
    }
    
    if (is_osc) {
        oscinterface = new OSCUI(filename, argc, argv);
        DSP->buildUserInterface(oscinterface);
    }
    
    if (is_midi) {
        midiinterface = new MidiUI(&audio);
        DSP->buildUserInterface(midiinterface);
    }
    
    if (nvoices > 0) {
        audio.addMidiIn(dsp_poly);
    }
    
    audio.start();

    if (is_httpd) {
        httpdinterface->run();
    }

    if (is_osc) {
        oscinterface->run();
    }
    
    if (is_midi) {
        midiinterface->run();
    }
    
    interface->run();

    audio.stop();
    
    finterface->saveState(rcfilename);
    
    delete DSP;
    delete interface;
    delete finterface;
    delete midiinterface;
    delete httpdinterface;
    delete oscinterface;
  
    //deleteDSPFactory(static_cast<llvm_dsp_factory*>(factory));
    
    deleteInterpreterDSPFactory(static_cast<interpreter_dsp_factory*>(factory));
    
    return 0;
}

