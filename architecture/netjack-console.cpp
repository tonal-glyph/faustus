/************************************************************************

	IMPORTANT NOTE : this file contains two clearly delimited sections :
	the ARCHITECTURE section (in two parts) and the USER section. Each section
	is governed by its own copyright and license. Please check individually
	each section for license and copyright information.
*************************************************************************/

/*******************BEGIN ARCHITECTURE SECTION (part 1/2)****************/

/************************************************************************
    FAUST Architecture File
    Copyright (C) 2003-2011 GRAME, Centre National de Creation Musicale
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

 ************************************************************************
 ************************************************************************/

#include <libgen.h>
#include <stdlib.h>
#include <iostream>
#include <cmath>

#include "faust/dsp/timed-dsp.h"
#include "faust/misc.h"
#include "faust/gui/FUI.h"
#include "faust/gui/console.h"
#include "faust/audio/netjack-dsp.h"

#ifdef OSCCTRL
#include "faust/gui/OSCUI.h"
#endif

#ifdef HTTPCTRL
#include "faust/gui/httpdUI.h"
#endif

// Always include this file, otherwise -nvoices only mode does not compile....
#include "faust/gui/MidiUI.h"

/**************************BEGIN USER SECTION **************************/

/******************************************************************************
*******************************************************************************

							       VECTOR INTRINSICS

*******************************************************************************
*******************************************************************************/

<<includeIntrinsic>>

<<includeclass>>

#include "faust/dsp/poly-dsp.h"

#ifdef POLY2
#include "faust/dsp/dsp-combiner.h"
#include "effect.h"
#endif

/***************************END USER SECTION ***************************/

/*******************BEGIN ARCHITECTURE SECTION (part 2/2)***************/

dsp* DSP;

std::list<GUI*> GUI::fGuiList;
ztimedmap GUI::gTimedZoneMap;

//-------------------------------------------------------------------------
// 									MAIN
//-------------------------------------------------------------------------
int main(int argc, char *argv[])
{
    char appname[256];
    char rcfilename[256];
    char* home = getenv("HOME");
    bool midi_sync = false;
    int nvoices = 0;
    int control = 0;
    mydsp_poly* dsp_poly = NULL;

    int celt = lopt(argv, "--c", -1);
    const char* master_ip = lopts(argv, "--a", DEFAULT_MULTICAST_IP);
    int master_port = lopt(argv, "--p", DEFAULT_PORT);
    int mtu = lopt(argv, "--M", DEFAULT_MTU);
    int latency = lopt(argv, "--l", 2);
    
    mydsp* tmp_dsp = new mydsp();
    MidiMeta::analyse(tmp_dsp, midi_sync, nvoices);
    delete tmp_dsp;
    
    snprintf(appname, 256, "%s", basename(argv[0]));
    snprintf(rcfilename, 256, "%s/.%src", home, appname);
    
    if (isopt(argv, "-h")) {
        std::cout << "prog [--nvoices <val>] [--control <0/1>] [--group <0/1>]\n";
        exit(1);
    }
    
#ifdef POLY2
    nvoices = lopt(argv, "--nvoices", nvoices);
    control = lopt(argv, "--control", control);
    int group = lopt(argv, "--group", 1);
    
    std::cout << "Started with " << nvoices << " voices\n";
    dsp_poly = new mydsp_poly(new mydsp(), nvoices, control, group);
    
#if MIDICTRL
    if (midi_sync) {
        DSP = new timed_dsp(new dsp_sequencer(dsp_poly, new effect()));
    } else {
        DSP = new dsp_sequencer(dsp_poly, new effect());
    }
#else
    DSP = new dsp_sequencer(dsp_poly, new effect());
#endif
    
#else
    nvoices = lopt(argv, "--nvoices", nvoices);
    control = lopt(argv, "--control", control);
    int group = lopt(argv, "--group", 1);
    
    if (nvoices > 0) {
        std::cout << "Started with " << nvoices << " voices\n";
        dsp_poly = new mydsp_poly(new mydsp(), nvoices, control, group);
        
#if MIDICTRL
        if (midi_sync) {
            DSP = new timed_dsp(dsp_poly);
        } else {
            DSP = dsp_poly;
        }
#else
        DSP = dsp_poly;
#endif
    } else {
#if MIDICTRL
        if (midi_sync) {
            DSP = new timed_dsp(new mydsp());
        } else {
            DSP = new mydsp();
        }
#else
        DSP = new mydsp();
#endif
    }
#endif
    
    if (DSP == 0) {
        std::cerr << "Unable to allocate Faust DSP object" << std::endl;
        exit(1);
    }

    CMDUI* interface = new CMDUI(argc, argv, true);
    FUI* finterface = new FUI();
    DSP->buildUserInterface(interface);
    DSP->buildUserInterface(finterface);

#ifdef HTTPCTRL
    httpdUI* httpdinterface = new httpdUI(appname, DSP->getNumInputs(), DSP->getNumOutputs(), argc, argv);
    DSP->buildUserInterface(httpdinterface);
#endif

#ifdef OSCCTRL
    GUI* oscinterface = new OSCUI(appname, argc, argv);
    DSP->buildUserInterface(oscinterface);
#endif

    netjackaudio_midicontrol audio(celt, master_ip, master_port, mtu, latency);
    if (!audio.init(appname, DSP)) {
        return 0;
    }
    finterface->recallState(rcfilename);
    if (!audio.start()) {
        return 0;
    }
    
#ifdef MIDICTRL
    MidiUI* midiinterface = new MidiUI(&audio);
    DSP->buildUserInterface(midiinterface);
    audio.addMidiIn(dsp_poly);
    std::cout << "MIDI is on" << std::endl;
#endif

#ifdef HTTPCTRL
    httpdinterface->run();
#endif

#ifdef OSCCTRL
    oscinterface->run();
#endif
    
#ifdef MIDICTRL
    if (!midiinterface->run()) {
        std::cerr << "MidiUI run error\n";
    }
#endif
    
    interface->run();

    audio.stop();
    finterface->saveState(rcfilename);
    
#ifdef MIDICTRL
    midiinterface->stop();
#endif
    
    // desallocation
    delete interface;
    delete finterface;
#ifdef HTTPCTRL
	 delete httpdinterface;
#endif
#ifdef OSCCTRL
	 delete oscinterface;
#endif
#ifdef MIDICTRL
    delete midiinterface;
#endif

    return 0;
}

/********************END ARCHITECTURE SECTION (part 2/2)****************/

