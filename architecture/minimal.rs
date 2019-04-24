/************************************************************************
************************************************************************
    FAUST Architecture File
    Copyright (C) 2017 GRAME, Centre National de Creation Musicale
    ---------------------------------------------------------------------
    This is sample code. This file is provided as an example of minimal
    FAUST architecture file. Redistribution and use in source and binary
    forms, with or without modification, in part or in full are permitted.
    In particular you can create a derived work of this FAUST architecture
    and distribute that work under terms of your choice.
    This sample code is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
************************************************************************
************************************************************************/
#![allow(unused_parens)]
#![allow(non_snake_case)]
#![allow(non_camel_case_types)]
use std::marker::PhantomData;
pub trait Meta {
    // -- metadata declarations
    fn declare(&mut self, key: &str, value: &str) -> ();
}
pub trait UI<T> {
    // -- widget's layouts
    fn openTabBox(&mut self, label: &str) -> ();
    fn openHorizontalBox(&mut self, label: &str) -> ();
    fn openVerticalBox(&mut self, label: &str) -> ();
    fn closeBox(&mut self) -> ();
    // -- active widgets
    fn addButton(&mut self, label: &str, zone: &mut T) -> ();
    fn addCheckButton(&mut self, label: &str, zone: &mut T) -> ();
    fn addVerticalSlider(&mut self, label: &str, zone: &mut T, init: T, min: T, max: T, step: T) -> ();
    fn addHorizontalSlider(&mut self, label: &str, zone: &mut T , init: T, min: T, max: T, step: T) -> ();
    fn addNumEntry(&mut self, label: &str, zone: &mut T, init: T, min: T, max: T, step: T) -> ();
    // -- passive widgets
    fn addHorizontalBargraph(&mut self, label: &str, zone: &mut T, min: T, max: T) -> ();
    fn addVerticalBargraph(&mut self, label: &str, zone: &mut T, min: T, max: T) -> ();
    // -- metadata declarations
    fn declare(&mut self, zone: &mut T, key: &str, value: &str) -> ();
}
pub struct PrintMeta {}
impl Meta for PrintMeta {
    fn declare(&mut self, key: &str, value: &str) -> ()
    {
        println!("declare: {} {}", key, value);
    }
}
pub struct PrintUI<T>
{
    phantom: PhantomData<T>
}
impl<T> UI<T> for PrintUI<T> {
    // -- widget's layouts
    fn openTabBox(&mut self, label: &str) -> ()
    {
        println!("openTabBox: {}", label);
    }
    fn openHorizontalBox(&mut self, label: &str) -> ()
    {
        println!("openHorizontalBox: {}", label);
    }
    fn openVerticalBox(&mut self, label: &str) -> ()
    {
        println!("openVerticalBox: {}", label);
    }
    fn closeBox(&mut self) -> ()
    {
        println!("closeBox:");
    }
    // -- active widgets
    fn addButton(&mut self, label: &str, zone: &mut T) -> ()
    {
        println!("addButton: {}", label);
    }
    fn addCheckButton(&mut self, label: &str, zone: &mut T) -> ()
    {
        println!("addCheckButton: {}", label);
    }
    fn addVerticalSlider(&mut self, label: &str, zone: &mut T, init: T, min: T, max: T, step: T) -> ()
    {
        println!("addVerticalSlider: {}", label);
    }
    fn addHorizontalSlider(&mut self, label: &str, zone: &mut T , init: T, min: T, max: T, step: T) -> ()
    {
        println!("addHorizontalSlider: {}", label);
    }
    fn addNumEntry(&mut self, label: &str, zone: &mut T, init: T, min: T, max: T, step: T) -> ()
    {
        println!("addNumEntry: {}", label);
    }
    // -- passive widgets
    fn addHorizontalBargraph(&mut self, label: &str, zone: &mut T, min: T, max: T) -> ()
    {
        println!("addHorizontalBargraph: {}", label);
    }
    fn addVerticalBargraph(&mut self, label: &str, zone: &mut T, min: T, max: T) -> ()
    {
        println!("addVerticalBargraph: {}", label);
    }
    // -- metadata declarations
    fn declare(&mut self, zone: &mut T, key: &str, value: &str) -> ()
    {
        println!("declare: {} {}", key, value);
    }
}
pub trait dsp<T> {
    //fn new() -> dsp<T>;
    fn getSampleRate(&mut self) -> i32;
    fn getNumInputs(&mut self) -> i32;
    fn getNumOutputs(&mut self) -> i32;
    fn getInputRate(&mut self, channel: i32) -> i32;
    fn getOutputRate(&mut self, channel: i32) -> i32;
    fn buildUserInterface(&mut self, ui_interface: &UI<T>) -> ();
    fn classInit(samplingFreq: i32) -> ();
    fn instanceResetUserInterface(&mut self) -> ();
    fn instanceClear(&mut self) -> ();
    fn instanceConstants(&mut self, samplingFreq: i32) -> ();
    fn instanceInit(&mut self, samplingFreq: i32) -> ();
    fn init(&mut self, samplingFreq: i32) -> ();
    fn compute(&mut self, count: i32, inputs: &[&[T]], outputs: &mut[&mut[T]]) -> ();
}
<<includeIntrinsic>>
<<includeclass>>
fn main() {
    println!("Faust Rust DSP");
    let mut dsp = Box::new(mydsp::new());
    println!("getNumInputs: {}", dsp.getNumInputs());
    println!("getNumOutputs: {}", dsp.getNumOutputs());
    // Init DSP with a given SR
    dsp.init(44100);
    // Print UI
    let mut printer = PrintUI::<f32>{ phantom: PhantomData };
    dsp.buildUserInterface(&mut printer);
    // Print Meta
    let mut meta = PrintMeta{};
    dsp.metadata(&mut meta);
    println!("getSampleRate: {}", dsp.getSampleRate());
    // Has to be done in the audio thread taking adapted "native" (JACK/PortAudio allocated...) audio buffers
    // dsp.compute(512, inputs, outputs);
}
