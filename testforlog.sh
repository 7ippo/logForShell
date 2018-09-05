#!/bin/bash

. ./logForShell.sh

_BeforeShell $@
_Step 1 "Copy Unity Resource"
_Success "Build Dynamic Framework Project"
_AfterShell
function a(){
    _Failure
}
function b(){
    a
}
b