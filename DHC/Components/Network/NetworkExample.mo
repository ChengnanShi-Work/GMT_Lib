within GMT_Lib.DHC.Components.Network;
model NetworkExample
  "This is the example model for isolated two pipe distribution network testing."
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Source side medium";
  parameter Integer nLoa=5
    "Number of served loads";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=10
    "Nominal mass flow rate in each load";
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nLoa]=fill(mLoa_flow_nominal,nLoa)
    "Nominal mass flow rate in each connection line";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=sum(
    mCon_flow_nominal)
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.SIunits.PressureDifference dp_nominal=sum(
    dis.con.pipDisSup.dp_nominal)+sum(
    dis.con.pipDisRet.dp_nominal)+max(
    res.dp_nominal)
    "Nominal pressure drop in the distribution line";
  Buildings.Experimental.DHC.Loads.Validation.BaseClasses.Distribution2Pipe dis(
    redeclare final package Medium=Medium,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=m_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    dpDis_nominal=fill(1500,nLoa))
    annotation (Placement(transformation(extent={{20,-60},{60,-40}})));
  Buildings.Fluid.FixedResistances.PressureDrop res[nLoa](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=mLoa_flow_nominal,
    each final dp_nominal(displayUnit="kPa") = 400000)
    "Flow resistance"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    V=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium=Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpPum(k=dp_nominal)
    "Prescribed head"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(vol.ports[1], pum.port_a) annotation (Line(points={{-92,-40},{-66,-40},
          {-66,-50},{-40,-50}}, color={0,127,255}));
  connect(pum.port_b, dis.port_aDisSup)
    annotation (Line(points={{-20,-50},{20,-50}},
                                                color={0,127,255}));
  connect(dis.port_bDisRet, vol.ports[2]) annotation (Line(points={{20,-56},
          {0,-56},{0,-80},{-88,-80},{-88,-40}},            color={0,127,255}));
  connect(dis.ports_bCon, res.port_a) annotation (Line(points={{28,-40},{0,-40},
          {0,50},{30,50}}, color={0,127,255}));
  connect(res.port_b, dis.ports_aCon) annotation (Line(points={{50,50},{80,50},{
          80,-40},{52,-40}}, color={0,127,255}));
  connect(dpPum.y, pum.dp_in)
    annotation (Line(points={{-38,-10},{-30,-10},{-30,-38}}, color={0,0,127}));
  annotation (experiment(StopTime=1000));
end NetworkExample;
