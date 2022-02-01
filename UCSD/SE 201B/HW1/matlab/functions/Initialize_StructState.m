function StructState = Initialize_StructState( U, DeltaU, deltaU)
    StructState.disp(1,1) = U; % Total displ.
    StructState.disp(1,2) = DeltaU; % Total incremental displ. since last converged state
    StructState.disp(1,3) = deltaU; % Last Incremental displ.
end