doc /* ConOps Level 0 Operational Lifecycle State Machine */
package ConOps {
    doc /* Compiler operational lifecycle state machine */
    state def CompilerLifecycleModes {
        state Bootstrapping;
        state Ingesting;
        state Compiling;
        state Verifying;
        state EmitSuccess;
        state FaultTerminated;
    }
}
