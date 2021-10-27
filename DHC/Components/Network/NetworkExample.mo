within GMT_Lib.DHC.Components.Network;
model NetworkExample
  "This is the example model for isolated two pipe distribution network testing."
  extends
    Buildings.Experimental.DHC.Loads.Validation.BenchmarkFlowDistribution2(
    nLoa=10);
end NetworkExample;
