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

#ifndef __TREETRANSFORM__
#define __TREETRANSFORM__

#include <stdlib.h>
#include <cstdlib>
#include "property.hh"
#include "sigtyperules.hh"
#include "tree.hh"

//------------------------------------------------------------------------------
// TreeTransform: Recursive transformation of a Tree with memoization
//------------------------------------------------------------------------------
// This is an abstract class. Derived class just have to implement the
// `transformation(t)` method. The `transformation(t)` method
// should not call itself recursively directly, but exclusively via `self(t)`
// (or `mapself(lt)` for a list).
//------------------------------------------------------------------------------

class TreeTransform {
   protected:
    property<Tree> fResult;  // cache previously computed transformations
    // used when tracing
    bool   fTraceFlag;  // trace transformations when true
    int    fIndent;     // current indentation during trace
    string fMessage;    // trace message

   public:
    TreeTransform() : fTraceFlag(false), fIndent(0), fMessage("TreeTransform") {}

    Tree self(Tree t);
    Tree mapself(Tree lt);

    void trace(bool b) { fTraceFlag = b; }
    void trace(bool b, const string& m)
    {
        fTraceFlag = b;
        fMessage   = m;
    }

   protected:
    virtual Tree transformation(Tree) = 0;   // the tranformation to implement
    virtual void traceEnter(Tree t);         // called when entering a transformation
    virtual void traceExit(Tree t, Tree r);  // called when exiting a transformation
};

#endif