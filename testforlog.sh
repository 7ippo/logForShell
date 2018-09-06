#!/bin/bash

. ./logForShell.sh

BeforeShell $@
Step 1 "Copy Unity Resource"
ReportSuccess "Build Dynamic Framework Project"
AfterShell
function a(){
    ReportFailure
}
function b(){
    a
}
b