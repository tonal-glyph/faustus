// build.rs
#![allow(
    dead_code,
    improper_ctypes,
    mutable_transmutes,
    non_camel_case_types,
    non_snake_case,
    non_upper_case_globals,
    unused_doc_comments,
    unused_imports,
    unused_mut
)]
extern crate bindgen;
extern crate cc;
#[macro_use] extern crate cfg_if;
extern crate dotenv;
use std::env;
use std::path::Path;
use std::path::PathBuf;
use std::fs;
use std::io::Write;
use std::process::Command;
fn add_cpp_files(builder: &mut cc::Build, path: &Path) {
    for e in path.read_dir().unwrap() {
        let e = e.unwrap();
        let path = e.path();
        if e.file_type().unwrap().is_dir() {
        } else if path.extension().and_then(|s| s.to_str()) == Some("cpp") {
            builder.file(&path);
        }
    }
}
fn add_c_files(builder: &mut cc::Build, path: &Path) {
    for e in path.read_dir().unwrap() {
        let e = e.unwrap();
        let path = e.path();
        if e.file_type().unwrap().is_dir() {
        } else if path.extension().and_then(|s| s.to_str()) == Some("c") {
            builder.file(&path);
        }
    }
}
cfg_if!
{
    if #[cfg(unix)] {
        fn build() {
            // /// Compile C/C++ sources
            // let mut builder = cc::Build::new();
            // dotenv::dotenv().ok();
            // builder.include("./src/include");
            // builder.include("./src/include/au");
            // builder.include("./compiler");
            // builder.flag_if_supported("-B --sysroot");
            // // builder.flag_if_supported("-DHAVE_CONFIG_H");
            // // builder.flag_if_supported("-DHAVE_POLL");
            // // builder.flag_if_supported("-DHAVE_LIBPTHREAD");
            // // builder.flag_if_supported("-DENABLE_THREADS");
            // // builder.flag_if_supported("-D__PLATFORM_LINUX__");
            // // builder.flag_if_supported("-D__LINUX_ALSA__");
            // // builder.flag_if_supported("-D__UNIX_JACK__");
            // // builder.flag_if_supported("-DUSE_ALSA");
            // // builder.flag_if_supported("-DUSE_DLTRICK_ALSA");
            // // builder.flag_if_supported("-DUSE_OSS");
            // builder.flag_if_supported("-fPIC");
            // builder.flag_if_supported("-fno-strict-aliasing");
            // builder.flag_if_supported("-fstack-protector-strong");
            // builder.flag_if_supported("-fno-plt");
            // builder.flag_if_supported("-fpermissive");
            // // builder.flag_if_supported("-I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include");
            // // builder.flag_if_supported("-I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include/c++");
            // builder.flag_if_supported("-O3");
            // builder.flag_if_supported("-mtune=generic");
            // builder.flag_if_supported("-march=native");
            // builder.flag_if_supported("-pipe");
            // let include_path = Path::new("./src/include");
            // add_c_files(&mut builder, include_path);
            // builder.cpp(true);
            // add_cpp_files(&mut builder, include_path);
            // builder.cpp_link_stdlib("stdc++");
            // builder.compile("libchuck.so");
            let bindings = bindgen::Builder::default()
                .generate_inline_functions(true)
                .derive_default(true)
                .header("./src/include/dsp/llvm-c-dsp.h")
                .clang_arg("-B --sysroot")
                // .clang_arg("-DHAVE_CONFIG_H")
                // .clang_arg("-DHAVE_LIBPTHREAD")
                // .clang_arg("-DHAVE_POLL")
                // .clang_arg("-DENABLE_THREADS")
                // .clang_arg("-D__CK_SNDFILE_NATIVE__")
                // .clang_arg("-D__LINUX_ALSA__")
                // .clang_arg("-D__PLATFORM_LINUX__")
                // .clang_arg("-D__UNIX_JACK__")
                // .clang_arg("-DUSE_ALSA")
                // .clang_arg("-DUSE_DLTRICK_ALSA")
                // .clang_arg("-DUSE_OSS")
                .clang_arg("-fPIC")
                .clang_arg("-fno-strict-aliasing")
                .clang_arg("-fstack-protector-strong")
                .clang_arg("-fno-plt")
                .clang_arg("-I./src/ck/")
                .clang_arg("-I./src/io/")
                .clang_arg("-I./src/ck/lo")
                .clang_arg("-I./src/ck/rgx")
                .clang_arg("-I./src/include")
                .clang_arg("-I./src/include/au")
                .clang_arg("-I./src/include/audio")
                .clang_arg("-I./src/include/dsp")
                .clang_arg("-I./src/include/gui")
                .clang_arg("-I./src/include/midi")
                .clang_arg("-I./src/include/osc")
                .clang_arg("-I./src/include/unity")
                .clang_arg("-I./src/include/vst")
                // .clang_arg("-I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include")
                // .clang_arg("-I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include/c++")
                .clang_arg("-O3")
                .clang_arg("-mtune=generic")
                .clang_arg("-march=native")
                .clang_arg("-pipe")
                .opaque_type("std::string")
                .opaque_type("std::vector")
                .opaque_type("std::map")
                .opaque_type("std::deque")
                .opaque_type("std::list")
                .opaque_type("std::hash")
                .blacklist_item("in_place_t")
                .generate()
                .expect("Unable to generate bindings");
            let _out_path = PathBuf::from("./src/");
            let mut bindings_string = bindings.to_string();
            let mut file = fs::File::create("./src/ffi.rs").unwrap();
            let _write = match file.write_all(bindings_string.as_bytes()) {
                Ok(r) => r,
                Err(e) => panic!("Unable to write bindings file: {}", e)
            };
            let _sync = match file.sync_data() {
                Ok(r) => r,
                Err(e) => panic!("Unable to sync: {}", e)
            };
        }
    } else {
        fn build() {
            unimplemented!();
        }
    }
}
fn main() {
    let linkage = env::var("CARGO_CFG_TARGET_FEATURE").unwrap_or(String::new());
    if linkage.contains("crt-static") {
        println!("the C runtime will be statically linked");
    } else {
        println!("the C runtime will be dynamically linked");
    }
    build()
}
