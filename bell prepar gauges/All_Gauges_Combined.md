<html><head><style>body{font-family:Arial;} pre{white-space: pre-wrap; word-wrap: break-word; background:#f4f4f4; padding:10px; border:1px solid #ddd;}</style></head><body><h1>AFCS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="AFCS" Version="1.0"&gt;
 &lt;Image Name="afcs_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="41" Y="24"/&gt;
    &lt;Image Name="afcs_1.bmp" PointsTo="South"&gt;
      &lt;Axis X="5" Y="5"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterDcBus,bool) if{ (A:RUDDER POSITION,percent) }&lt;/Value&gt;
       &lt;Nonlinearity&gt;
	   &lt;Item Value="100" X="70" Y="54"/&gt;
         &lt;Item Value="0" X="41" Y="65"/&gt;
         &lt;Item Value="-100" X="12" Y="54"/&gt;
       &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="30"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="130" Y="56"/&gt;
    &lt;Image Name="afcs_2.bmp" PointsTo="North"&gt;
      &lt;Axis X="5" Y="41"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterDcBus,bool) if{ (A:AILERON POSITION,percent) }&lt;/Value&gt;
       &lt;Nonlinearity&gt;
	   &lt;Item Value="-100" X="104" Y="24"/&gt;
         &lt;Item Value="0" X="130" Y="15"/&gt;
         &lt;Item Value="100" X="155" Y="24"/&gt;
       &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="30"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="233" Y="40"/&gt;
    &lt;Image Name="afcs_3.bmp" PointsTo="West"&gt;
      &lt;Axis X="40" Y="5"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterDcBus,bool) if{ (A:ELEVATOR POSITION,percent) }&lt;/Value&gt;
       &lt;Nonlinearity&gt;
	   &lt;Item Value="-100" X="200" Y="66"/&gt;
         &lt;Item Value="0" X="192" Y="40"/&gt;
         &lt;Item Value="100" X="204" Y="10"/&gt;
       &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="30"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>AHRS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="AHRS" Version="1.0"&gt;
 &lt;Image Name="ahrs_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="44" Y="56"/&gt;
    &lt;Image Name="afcs_2.bmp" PointsTo="North"&gt;
      &lt;Axis X="5" Y="41"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="-0.2" Maximum="0.2"&gt;(L:MasterDcBus,bool) if{ (A:ATTITUDE INDICATOR BANK DEGREES,radians) }&lt;/Value&gt;
       &lt;Nonlinearity&gt;
	   &lt;Item Value="-0.2" X="67" Y="22"/&gt;
         &lt;Item Value="0" X="44" Y="16"/&gt;
         &lt;Item Value="0.2" X="21" Y="22"/&gt;
       &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="30"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Airspeed.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Airspeed" Version="1.0"&gt;
 &lt;Image Name="airspeed_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="airspeed_needle.bmp"&gt;
      &lt;Axis X="45" Y="7"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:EngineCovers,bool) 0 == if{ (A:AIRSPEED INDICATED,Knots) }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="122" Y="30"/&gt;
          &lt;Item Value="20" X="137" Y="30"/&gt;
          &lt;Item Value="30" X="179" Y="47"/&gt;
          &lt;Item Value="40" X="219" Y="113"/&gt;
          &lt;Item Value="50" X="206" Y="176"/&gt;
          &lt;Item Value="60" X="180" Y="203"/&gt;
          &lt;Item Value="70" X="143" Y="219"/&gt;
          &lt;Item Value="80" X="106" Y="219"/&gt;
          &lt;Item Value="90" X="69" Y="204"/&gt;
		  &lt;Item Value="100" X="43" Y="177"/&gt;
          &lt;Item Value="110" X="29" Y="143"/&gt;
          &lt;Item Value="120" X="30" Y="104"/&gt;
          &lt;Item Value="130" X="43" Y="74"/&gt;
		  &lt;Item Value="140" X="65" Y="48"/&gt;
		  &lt;Item Value="150" X="94" Y="33"/&gt;
       &lt;/Nonlinearity&gt;
       &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
      &lt;Help ID="HELPID_GAUGE_AIRSPEED"/&gt;
      &lt;Tooltip ID="TOOLTIPTEXT_AIRSPEED_KNOTS"/&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Alt.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Alt" Version="1.0"&gt;
 &lt;Image Name="Alt_background.bmp"/&gt;
 
   &lt;Element&gt;
    &lt;Position X="49" Y="119"/&gt;
    &lt;MaskImage Name="alt_win.bmp"&gt;
      &lt;Axis X="0" Y="7.5"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="alt_strip_Mb.bmp"&gt;
       &lt;Nonlinearity&gt; 
          &lt;Item Value="31.0" X="0" Y="367"/&gt;
          &lt;Item Value="29.5" X="0" Y="187"/&gt;
		  &lt;Item Value="28.0" X="0" Y="7"/&gt;          
       &lt;/Nonlinearity&gt;
    &lt;/Image&gt; 
    &lt;Shift&gt;
       &lt;Value&gt;(A:Kohlsman setting hg,inHg)&lt;/Value&gt;
    &lt;/Shift&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="177" Y="116"/&gt;
    &lt;MaskImage Name="alt_win.bmp"&gt;
      &lt;Axis X="0" Y="7.5"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="alt_strip_InHg.bmp"&gt;
       &lt;Nonlinearity&gt; 
          &lt;Item Value="28.0" X="0" Y="7"/&gt;
          &lt;Item Value="29.5" X="0" Y="187"/&gt;
          &lt;Item Value="31.0" X="0" Y="367"/&gt;
       &lt;/Nonlinearity&gt;
    &lt;/Image&gt; 
    &lt;Shift&gt;
       &lt;Value Minimum="28.0" Maximum="31.0"&gt;(A:Kohlsman setting hg,inHg)&lt;/Value&gt;
    &lt;/Shift&gt;
  &lt;/Element&gt;
  
   &lt;!-- ======================= 10,000's Feet Needle =================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_10000.bmp"&gt;
      &lt;Axis X="40" Y="30"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet)&lt;/Value&gt;
       &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="10000" X="183" Y="41"/&gt;
          &lt;Item Value="20000" X="221" Y="91"/&gt;
          &lt;Item Value="30000" X="220" Y="155"/&gt;
          &lt;Item Value="40000" X="183" Y="205"/&gt;
          &lt;Item Value="50000" X="124" Y="224"/&gt;
          &lt;Item Value="60000" X="65" Y="205"/&gt;
          &lt;Item Value="70000" X="28" Y="155"/&gt;
          &lt;Item Value="80000" X="28" Y="91"/&gt;
          &lt;Item Value="90000" X="65" Y="41"/&gt;
      &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  
     &lt;!-- ======================= 1000's Feet Needle ===================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_1000.bmp"&gt;
      &lt;Axis X="29" Y="22"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet) 10000 % &lt;/Value&gt;
       &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
       &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="1000" X="183" Y="41"/&gt;
          &lt;Item Value="2000" X="221" Y="91"/&gt;
          &lt;Item Value="3000" X="220" Y="155"/&gt;
          &lt;Item Value="4000" X="183" Y="205"/&gt;
          &lt;Item Value="5000" X="124" Y="224"/&gt;
          &lt;Item Value="6000" X="65" Y="205"/&gt;
          &lt;Item Value="7000" X="28" Y="155"/&gt;
          &lt;Item Value="8000" X="28" Y="91"/&gt;
          &lt;Item Value="9000" X="65" Y="41"/&gt;
       &lt;/Nonlinearity&gt;
   &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;!-- ======================= 100's Feet Needle ====================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_100.bmp"&gt;
      &lt;Axis X="23" Y="11"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet) 1000 % &lt;/Value&gt;
      &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="100" X="183" Y="41"/&gt;
          &lt;Item Value="200" X="221" Y="91"/&gt;
          &lt;Item Value="300" X="220" Y="155"/&gt;
          &lt;Item Value="400" X="183" Y="205"/&gt;
          &lt;Item Value="500" X="124" Y="224"/&gt;
          &lt;Item Value="600" X="65" Y="205"/&gt;
          &lt;Item Value="700" X="28" Y="155"/&gt;
          &lt;Item Value="800" X="28" Y="91"/&gt;
          &lt;Item Value="900" X="65" Y="41"/&gt;
         &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
 &lt;Mouse&gt;
     &lt;Help ID="HELPID_GAUGE_ALTIMETER"/&gt;
     &lt;Tooltip ID="TOOLTIPTEXT_ALTIMETER_FEET" MetricID="TOOLTIPTEXT_ALTIMETER_FEET_METERS_SPECIAL"/&gt;
     
     &lt;Area Left="11" Top="199" Width="40" Height="40"&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_ALTIMETER_KOHLSMAN_INHG" MetricID="TOOLTIPTEXT_ALTIMETER_KOHLSMAN_MBAR"/&gt;
        &lt;Area Right="20"&gt;
          &lt;Cursor Type="DownArrow"/&gt;
          &lt;Click Event="KOHLSMAN_DEC" Repeat="Yes"/&gt;
        &lt;/Area&gt;
        &lt;Area Left="20"&gt;
          &lt;Cursor Type="UpArrow"/&gt;
          &lt;Click Event="KOHLSMAN_INC" Repeat="Yes"/&gt;
        &lt;/Area&gt;
     &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>ALTC.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="ALTC" Version="1.0"&gt;
 &lt;Image Name="Alt2_background.bmp"/&gt;
 
   &lt;Element&gt;
    &lt;Position X="49" Y="119"/&gt;
    &lt;MaskImage Name="alt_win.bmp"&gt;
      &lt;Axis X="0" Y="7.5"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="alt_strip_Mb.bmp"&gt;
       &lt;Nonlinearity&gt; 
          &lt;Item Value="31.0" X="0" Y="367"/&gt;
          &lt;Item Value="29.5" X="0" Y="187"/&gt;
		  &lt;Item Value="28.0" X="0" Y="7"/&gt;          
       &lt;/Nonlinearity&gt;
    &lt;/Image&gt; 
    &lt;Shift&gt;
       &lt;Value&gt;(A:Kohlsman setting hg,inHg)&lt;/Value&gt;
    &lt;/Shift&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="177" Y="116"/&gt;
    &lt;MaskImage Name="alt_win.bmp"&gt;
      &lt;Axis X="0" Y="7.5"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="alt_strip_InHg.bmp"&gt;
       &lt;Nonlinearity&gt; 
          &lt;Item Value="28.0" X="0" Y="7"/&gt;
          &lt;Item Value="29.5" X="0" Y="187"/&gt;
          &lt;Item Value="31.0" X="0" Y="367"/&gt;
       &lt;/Nonlinearity&gt;
    &lt;/Image&gt; 
    &lt;Shift&gt;
       &lt;Value Minimum="28.0" Maximum="31.0"&gt;(A:Kohlsman setting hg,inHg)&lt;/Value&gt;
    &lt;/Shift&gt;
  &lt;/Element&gt;
  
   &lt;!-- ======================= 10,000's Feet Needle =================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_10000.bmp"&gt;
      &lt;Axis X="40" Y="30"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet)&lt;/Value&gt;
       &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="10000" X="183" Y="41"/&gt;
          &lt;Item Value="20000" X="221" Y="91"/&gt;
          &lt;Item Value="30000" X="220" Y="155"/&gt;
          &lt;Item Value="40000" X="183" Y="205"/&gt;
          &lt;Item Value="50000" X="124" Y="224"/&gt;
          &lt;Item Value="60000" X="65" Y="205"/&gt;
          &lt;Item Value="70000" X="28" Y="155"/&gt;
          &lt;Item Value="80000" X="28" Y="91"/&gt;
          &lt;Item Value="90000" X="65" Y="41"/&gt;
      &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  
     &lt;!-- ======================= 1000's Feet Needle ===================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_1000.bmp"&gt;
      &lt;Axis X="29" Y="22"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet) 10000 % &lt;/Value&gt;
       &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
       &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="1000" X="183" Y="41"/&gt;
          &lt;Item Value="2000" X="221" Y="91"/&gt;
          &lt;Item Value="3000" X="220" Y="155"/&gt;
          &lt;Item Value="4000" X="183" Y="205"/&gt;
          &lt;Item Value="5000" X="124" Y="224"/&gt;
          &lt;Item Value="6000" X="65" Y="205"/&gt;
          &lt;Item Value="7000" X="28" Y="155"/&gt;
          &lt;Item Value="8000" X="28" Y="91"/&gt;
          &lt;Item Value="9000" X="65" Y="41"/&gt;
       &lt;/Nonlinearity&gt;
   &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;!-- ======================= 100's Feet Needle ====================== --&gt;
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="alt_needle_100.bmp"&gt;
      &lt;Axis X="23" Y="11"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Indicated Altitude, feet) 1000 % &lt;/Value&gt;
      &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="123" Y="22"/&gt;
          &lt;Item Value="100" X="183" Y="41"/&gt;
          &lt;Item Value="200" X="221" Y="91"/&gt;
          &lt;Item Value="300" X="220" Y="155"/&gt;
          &lt;Item Value="400" X="183" Y="205"/&gt;
          &lt;Item Value="500" X="124" Y="224"/&gt;
          &lt;Item Value="600" X="65" Y="205"/&gt;
          &lt;Item Value="700" X="28" Y="155"/&gt;
          &lt;Item Value="800" X="28" Y="91"/&gt;
          &lt;Item Value="900" X="65" Y="41"/&gt;
         &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
 &lt;Mouse&gt;
     &lt;Help ID="HELPID_GAUGE_ALTIMETER"/&gt;
     &lt;Tooltip ID="TOOLTIPTEXT_ALTIMETER_FEET" MetricID="TOOLTIPTEXT_ALTIMETER_FEET_METERS_SPECIAL"/&gt;
     
     &lt;Area Left="11" Top="199" Width="40" Height="40"&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_ALTIMETER_KOHLSMAN_INHG" MetricID="TOOLTIPTEXT_ALTIMETER_KOHLSMAN_MBAR"/&gt;
        &lt;Area Right="20"&gt;
          &lt;Cursor Type="DownArrow"/&gt;
          &lt;Click Event="KOHLSMAN_DEC" Repeat="Yes"/&gt;
        &lt;/Area&gt;
        &lt;Area Left="20"&gt;
          &lt;Cursor Type="UpArrow"/&gt;
          &lt;Click Event="KOHLSMAN_INC" Repeat="Yes"/&gt;
        &lt;/Area&gt;
     &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>AMPS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="AMPS" Version="1.0"&gt;
 &lt;Image Name="amps_background.bmp"/&gt;


  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="300"&gt;(L:Genel,bool) 1 == if{ (L:Ampsg1,amp) }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="0" X="54" Y="137"/&gt;
		  &lt;Item Value="100" X="25" Y="109"/&gt;
		  &lt;Item Value="200" X="26" Y="66"/&gt;
		  &lt;Item Value="300" X="56" Y="40"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="300"&gt;(L:Gener,bool) 1 == if{ (L:Ampsg2,amp) }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="300" Degrees="-71"/&gt;
          &lt;Item Value="200" Degrees="-26"/&gt;
          &lt;Item Value="100" Degrees="23"/&gt;		  		  		
		  &lt;Item Value="0" Degrees="68.8"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="amps_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!--amp 1 --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Generator 1 (%((L:Genel,bool) 1 == if{ (L:Ampsg1,amp) })%!d!amp)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- amp 2 --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Generator 2 (%((L:Gener,bool) 1 == if{ (L:Ampsg2,amp) })%!d!amp)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>AP.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="AP" Version="1.0"&gt;
 &lt;Image Name="AP.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="Ap_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>AP_C.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="AP_C" Version="1.0"&gt;
 &lt;Image Name="Ap_c.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="Ap_c_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>ATT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="ATT" Version="1.0"&gt;
 &lt;Image Name="att_background.bmp"/&gt;

  &lt;Element&gt;
   &lt;Position X="0" Y="0"/&gt;
   &lt;MaskImage Name="att_win.bmp"&gt;
      &lt;Axis X="170" Y="165"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="att_horizon.bmp"&gt;
      &lt;Axis X="147" Y="147"/&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
      &lt;Value&gt;(L:MasterACDC, bool) if{ (A:ATTITUDE INDICATOR PITCH DEGREES,degrees) /-/ } &lt;/Value&gt;
      &lt;Scale Y="2.2"/&gt;
    &lt;/Shift&gt;
    &lt;Rotate&gt;
       &lt;Value&gt;(L:MasterACDC, bool) if{ (A:ATTITUDE INDICATOR BANK DEGREES,radians) } els{ 0.50 }&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt; 
    &lt;Position X="170" Y="165"/&gt;
    &lt;Image Name="att_pointer.bmp" PointsTo="east"&gt;
      &lt;Axis X="6" Y="102"/&gt;
    &lt;/Image&gt;
	&lt;Rotate&gt;
      &lt;Value&gt;(G:Var2) 1 * dgrd &lt;/Value&gt;
    &lt;/Rotate&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterACDC, bool) if{ (A:Attitude indicator bank degrees,radians) }&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
&lt;!-- ======================= flag ================================= --&gt;

&lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
     &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="63" Y="255"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_flag.bmp" PointsTo="Weast"&gt;
      &lt;Axis X="2" Y="33"/&gt;
    &lt;/Image&gt;
     &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterACDC, bool)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	    &lt;Item Value="0" Degrees="0"/&gt;
   	    &lt;Item Value="1" Degrees="115"/&gt;
	  &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="190"/&gt;
    &lt;/Rotate&gt;
&lt;/Element&gt;

&lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
     &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="38" Y="183"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_gs.bmp" PointsTo="Weast"&gt;
      &lt;Axis X="0" Y="35"/&gt;
    &lt;/Image&gt;
     &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterACDC, bool)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	  &lt;Item Value="1" Degrees="-70"/&gt;
	  &lt;Item Value="0" Degrees="0"/&gt;
	 &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="190"/&gt;
    &lt;/Rotate&gt;
&lt;/Element&gt;

&lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
     &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="92" Y="47"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_fd.bmp" PointsTo="Weast"&gt;
      &lt;Axis X="13" Y="0"/&gt;
    &lt;/Image&gt;
     &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterACDC, bool)&lt;/Value&gt;
     &lt;Nonlinearity&gt;
	  &lt;Item Value="0" Degrees="0"/&gt;
	  &lt;Item Value="1" Degrees="70"/&gt;
	 &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="190"/&gt;
    &lt;/Rotate&gt;
&lt;/Element&gt;

&lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
     &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="303" Y="240"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_rt.bmp"&gt;
      &lt;Axis X="25" Y="30"/&gt;
    &lt;/Image&gt;
     &lt;Rotate&gt;
      &lt;Value&gt;(L:MasterACDC, bool)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
      	&lt;Item Value="0" Degrees="0"/&gt;
	    &lt;Item Value="1" Degrees="-78"/&gt;
	 &lt;/Nonlinearity&gt;
      &lt;Delay DegreesPerSecond="190"/&gt;
    &lt;/Rotate&gt;
&lt;/Element&gt;

 &lt;!-- ======================= Aircraft Symbol ==================== --&gt;
  &lt;Element&gt;
    &lt;Position X="44" Y="165"/&gt;
     &lt;Image Name="att_aircraft.bmp" PointsTo="Weast"&gt;
      &lt;Axis X="0" Y="0"/&gt;
    &lt;/Image&gt;
    &lt;Shift&gt;
      &lt;Value Minimum="-70" Maximum="70"&gt;(G:Var1)&lt;/Value&gt;
      &lt;Scale Y="1"/&gt;
    &lt;/Shift&gt;
   &lt;/Element&gt;

 &lt;Element&gt;
  &lt;Position X="0" Y="0"/&gt;
    &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="170" Y="22"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_needle_1.bmp"&gt;
          &lt;Axis X="17" Y="0"/&gt;
     &lt;/Image&gt;
     &lt;Shift&gt;
      &lt;Value&gt;(L:MasterACDC, bool) if{ (A:NAV CDI:1, number) (L:Mlocnav, number) + }&lt;/Value&gt;
      &lt;Scale X="0.65"/&gt;
      &lt;Delay PixelsPerSecond="80"/&gt;
   &lt;/Shift&gt;
 &lt;/Element&gt;
 
 &lt;Element&gt;
  &lt;Position X="0" Y="0"/&gt;
    &lt;MaskImage Name="att_win_2.bmp"&gt;
      &lt;Axis X="44" Y="169"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="att_needle_2.bmp"&gt;
          &lt;Axis X="0" Y="17"/&gt;
     &lt;/Image&gt;
     &lt;Shift&gt;
      &lt;Value&gt;(L:MasterACDC, bool) if{ (A:NAV GSI:1, number) (L:Mgsnav, number) + }&lt;/Value&gt;
      &lt;Scale Y="0.30"/&gt;
      &lt;Delay PixelsPerSecond="80"/&gt;
   &lt;/Shift&gt;
 &lt;/Element&gt;

&lt;!-- ======================= Cage Knob =========================== --&gt;
  &lt;Element&gt;
    &lt;Position X="380" Y="134"/&gt;
    &lt;Image Name="att_cage.bmp"&gt;
      &lt;Axis X="29.5" Y="29.5"/&gt;
    &lt;/Image&gt;
     &lt;Rotate&gt;
      &lt;Value&gt;(G:Var1) -10 * dgrd&lt;/Value&gt;
      &lt;Delay DegreesPerSecond="90"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="383" Y="220"/&gt;
    &lt;Image Name="att_knob.bmp"&gt;
      &lt;Axis X="29.5" Y="29.5"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(G:Var2) 10 * dgrd&lt;/Value&gt;
      &lt;Delay DegreesPerSecond="90"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
&lt;!-- ======================= Skid Ball =========================== --&gt;
&lt;Element&gt;
  &lt;Image Name="att_ball.bmp"&gt;
      &lt;Axis X="8" Y="8"/&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:Turn coordinator ball,position)&lt;/Value&gt;
    &lt;Nonlinearity&gt;
	   &lt;Item Value="-1" X="137" Y="301"/&gt;
       &lt;Item Value="0" X="170" Y="303"/&gt;
       &lt;Item Value="1" X="203" Y="301"/&gt;
    &lt;/Nonlinearity&gt;
    &lt;Delay PixelsPerSecond="20"/&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Image Name="att_bank.bmp"&gt;
      &lt;Axis X="9" Y="8"/&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value Minimum="-1.5" Maximum="1.5"&gt;(A:Delta heading rate,rpm)&lt;/Value&gt;
    &lt;Nonlinearity&gt;
	   &lt;Item Value="-1.5" X="137" Y="330"/&gt;
       &lt;Item Value="0" X="170" Y="330"/&gt;
       &lt;Item Value="1.5" X="203" Y="330"/&gt;
    &lt;/Nonlinearity&gt;
    &lt;Delay PixelsPerSecond="20"/&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

 &lt;Element&gt;
    &lt;Position X="160" Y="293"/&gt;
    &lt;Image Name="att_tube_lines.bmp"/&gt;
 &lt;/Element&gt;
 
  &lt;Mouse&gt;
 &lt;!-- CAGE Knob --&gt;
    &lt;Area Left="351" Top="105" Width="60" Height="60"&gt;
      &lt;Area Right="30"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
          (G:Var1) 1 + 12 min (&amp;gt;G:Var1)
        &lt;/Click&gt;
      &lt;/Area&gt;
      &lt;Area Left="30"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
          (G:Var1) 1 - -12 max (&amp;gt;G:Var1)
        &lt;/Click&gt;
      &lt;/Area&gt;
    &lt;/Area&gt;

   &lt;Area Left="354" Top="191" Width="60" Height="60"&gt;
	&lt;Area Left="30"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
		  (G:Var2) 1 + 30 min (&amp;gt;G:Var2)
        &lt;/Click&gt;
      &lt;/Area&gt;
      &lt;Area Right="30"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
          (G:Var2) 1 - -30 max (&amp;gt;G:Var2)
        &lt;/Click&gt;
      &lt;/Area&gt;
    &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_AFT_INT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_1_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Testaft,bool) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_aft_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Mouse&gt;
    &lt;Tooltip ID=""&gt;Test&lt;/Tooltip&gt;
	  &lt;Cursor Type="Hand"/&gt;
	  &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:Testaft,bool) 0 == and if{ 1 (&amp;gt;L:Testaft,bool) }
  		(M:Event) 'Leave' scmp 0 == (L:Testaft,bool) 1 == and if{ 0 (&amp;gt;L:Testaft,bool) }			
	  &lt;/Click&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_BAGG.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_baggage_b.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Test,bool) || (L:firetestbag,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_baggage_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_CR.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:CRTest, bool) || (L:Swcargorel,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_cargor_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
&lt;Mouse&gt;
 &lt;Tooltip ID=""&gt;Test&lt;/Tooltip&gt;
  &lt;Cursor Type="Hand"/&gt;
   &lt;Click Kind="LeftSingle+Leave"&gt;
	(M:Event) 'LeftSingle' scmp 0 == (L:CRTest, bool) 0 == and if{ 1 (&amp;gt;L:CRTest, bool) }
    (M:Event) 'Leave' scmp 0 == (L:CRTest, bool) 1 == and if{ 0 (&amp;gt;L:CRTest, bool) }			
   &lt;/Click&gt;
&lt;/Mouse&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_E1OUT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_eng1o_b.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) || (L:RPM N1 E1,percent) 55 &amp;lt;= || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_eng1o_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_E2OUT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_eng2o_b.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) || (L:RPM N1 E2,percent) 55 &amp;lt;= || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_eng2o_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_FIRE1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_fire1_b.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Swfiretest,bool) || (L:firethandl,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_fire1_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
  &lt;Mouse&gt;
   &lt;Tooltip ID=""&gt;Fire 1 Pull Handle Switch&lt;/Tooltip&gt;
    &lt;Cursor Type="Hand"/&gt;
       &lt;Click&gt;(L:firethandl,bool) ! (&amp;gt;L:firethandl,bool)&lt;/Click&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_FIRE2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_fire2_b.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Swfiretest,bool) || (L:firethandr,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_fire2_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
  &lt;Mouse&gt;
   &lt;Tooltip ID=""&gt;Fire 2 Pull Handle Switch&lt;/Tooltip&gt;
    &lt;Cursor Type="Hand"/&gt;
       &lt;Click&gt;(L:firethandr,bool) ! (&amp;gt;L:firethandr,bool)&lt;/Click&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_FT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:AFTcall,bool) || (L:Sw forcetrim,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_ft_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
&lt;Mouse&gt;
 &lt;Tooltip ID=""&gt;Test&lt;/Tooltip&gt;
  &lt;Cursor Type="Hand"/&gt;
   &lt;Click Kind="LeftSingle+Leave"&gt;
	(M:Event) 'LeftSingle' scmp 0 == (L:AFTcall,bool) 0 == and if{ 1 (&amp;gt;L:AFTcall,bool) }
    (M:Event) 'Leave' scmp 0 == (L:AFTcall,bool) 1 == and if{ 0 (&amp;gt;L:AFTcall,bool) }			
   &lt;/Click&gt;
&lt;/Mouse&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_MASTERC.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_masterc_background.bmp"/&gt;

   &lt;Element&gt;
     &lt;Select&gt;
       &lt;Value&gt;(L:MasterDcBus,bool) if{
(L:TestMC,enum) || (L:OILE1,psi) 50 &amp;lt; || (L:OILE2,psi) 50 &amp;lt; || (L:SwvalveEng1,bool) 0 == || (L:SwvalveEng2,bool) 0 == || (L:SwboostpuEng1,bool) 0 == || (L:SwboostpuEng2,bool) 0 == || (L:SwfueltransengA,bool) 0 == || (L:SwfueltransengB,bool) 0 == || (L:Swbatta,bool) (L:Swbattb,bool) 1 == &amp;amp;&amp;amp; || (A:FUEL TANK CENTER LEVEL,percent) 9.2 &amp;lt; || (L:Swfuelintcon,bool) || (L:SwFuelxfeed,bool) || (L:SepP1,bool) == 0 || (L:SwpartsepA,bool)  || (L:SepP2,bool) == 0 || (L:SwpartsepB,bool) || (L:SwGovA,bool) || (L:SwGovB,bool) || (L:CGenel,bool) 0 == || (L:CGener,bool) 0 == || (A:Rotor Brake Active,bool) || (L:Swinva, bool) 0 == || (L:Swinvb, bool) 0 == || (L:SwHeater,bool) || (L:Door passenger l,percent) || (L:Door passenger r,percent) || (L:Door baggage,position) || (L:Gbox, psi) 40 &amp;lt; || (L:XMSN,psi) 30 &amp;lt; || (L:GboxT, celsius) 0 &amp;lt; || (L:XMSNT,celsius) 0 &amp;lt; || (L:Sw hydsysA,bool) || (L:Sw hydsysB,bool) || (L:ExternalPower,bool) ||
		}		 
	   &lt;/Value&gt;
       &lt;Case Value="1"&gt;
          &lt;Image Name="a_masterc_on.bmp" Bright="Yes"/&gt;
       &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
 
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_OTORQUE.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Overtq,bool) || (L:Trotor,percent) 100 &amp;gt; || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_otorque_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;

&lt;Mouse&gt;
 &lt;Tooltip ID=""&gt;Over Torque Test&lt;/Tooltip&gt;
  &lt;Cursor Type="Hand"/&gt;
   &lt;Click Kind="LeftSingle+Leave"&gt;
	(M:Event) 'LeftSingle' scmp 0 == (L:Overtq,bool) 0 == and if{ 1 (&amp;gt;L:Overtq,bool) }
    (M:Event) 'Leave' scmp 0 == (L:Overtq,bool) 1 == and if{ 0 (&amp;gt;L:Overtq,bool) }			
   &lt;/Click&gt;
&lt;/Mouse&gt;
   
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>A_RPM.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (A:Rotor RPM PCT:1, percent) s0 95 &amp;lt;= s1 l0 100 &amp;gt; l1 || (L:TestMC,enum) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="a_rpm_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>BELT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="belts_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Genmast,bool) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="belts_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Clock.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Clock" Version="1.0"&gt;
 &lt;Image Name="clock_background.bmp"/&gt;
 
 
 &lt;Element&gt;
  &lt;Position X="15" Y="40"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterDcBus,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="clock_bg_on.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
   &lt;Element&gt;
   &lt;Visible&gt;(L:MasterDcBus,bool)&lt;/Visible&gt;
    &lt;Position X="45" Y="45"/&gt;
      &lt;Text X="87" Y="26" Length="8" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="#010707" Bright="Yes"&gt;
         &lt;String&gt;%((G:Var3) 0 &amp;gt; if{ (G:Var3) -- d (&amp;gt;G:Var3) 0 == if{ 0 (&amp;gt;G:Var1) } } (G:Var1))%{case}%{:0}%((P:Local time,hours) 24 % flr)%!02d%((P:Local time, seconds) 1 % 2 * flr)%{if}:%{else} %{end}%((P:Local time,minutes) 60 % flr)%!02d%{:1}%((P:Local day of month, number))%!2d %((P:Local month of year, number))%!2d%{:2}%((P:Local year, number))%!5d!%{end}&lt;/String&gt;
      &lt;/Text&gt;
   &lt;/Element&gt;
   
      
   &lt;Mouse&gt;
    &lt;Area Left="1" Top="125" Width="15" Height="24"&gt;
       &lt;Cursor Type="Hand"/&gt;
       &lt;Click&gt;(G:Var1) ++ 3 % d (&amp;gt;G:Var1) 0 &amp;gt; if{ 180 (&amp;gt;G:Var3) }&lt;/Click&gt;
     &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>COMPASS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Comp" Version="1.0"&gt;
 &lt;Image Name="c_background.bmp"/&gt;
 
   &lt;Element&gt;
      &lt;MaskImage Name="c_win.bmp"&gt;
         &lt;Axis X="129" Y="122"/&gt;
      &lt;/MaskImage&gt;
      &lt;Image Name="c_card.bmp"&gt;
         &lt;Nonlinearity&gt;
            &lt;Item Value="360" X="84" Y="19"/&gt;
            &lt;Item Value="180" X="300" Y="19"/&gt;					 
            &lt;Item Value="0" X="516" Y="19"/&gt;
         &lt;/Nonlinearity&gt;
      &lt;/Image&gt;
      &lt;Shift&gt;
         &lt;Value&gt;(A:Wiskey compass indication degrees,degrees) dnor&lt;/Value&gt;
      &lt;/Shift&gt;
   &lt;/Element&gt;&gt;
  
 &lt;Element&gt;
    &lt;Position X="128" Y="65"/&gt;
    &lt;Image Name="c_m.bmp"/&gt;
 &lt;/Element&gt;
  
  &lt;Mouse&gt;
    &lt;Tooltip ID="TOOLTIPTEXT_WHISKEY_COMPASS"/&gt;
  &lt;/Mouse&gt;
  
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>CSI.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="CSI" Version="1.0"&gt;
 &lt;Image Name="csi_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
   &lt;MaskImage Name="csi_win.bmp"&gt;
      &lt;Axis X="125" Y="123"/&gt;
    &lt;/MaskImage&gt;
    &lt;Image Name="csi_card.bmp" PointsTo="North"&gt;
      &lt;Axis X="94" Y="94"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:NAV2 OBS,degrees) 90 + - dgrd&lt;/Value&gt;
   &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="93" Y="132"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(A:NAV GS FLAG:2,bool)&lt;/Value&gt;
       &lt;Case Value="0"&gt;
          &lt;Image Name="csi_gs_flag.bmp"/&gt;
       &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="142" Y="82"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(A:NAV HAS NAV:2,bool)&lt;/Value&gt;
       &lt;Case Value="0"&gt;
          &lt;Image Name="csi_nav_flag.bmp"/&gt;
       &lt;/Case&gt;
      &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="147" Y="136"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(A:NAV TOFROM:2, ENUM)&lt;/Value&gt;
       &lt;Case Value="1"&gt;
          &lt;Image Name="csi_to_flag.bmp"/&gt;
       &lt;/Case&gt;
	 &lt;Case Value="2"&gt;
          &lt;Image Name="csi_from_flag.bmp"/&gt;
       &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="65" Y="117"/&gt;
    &lt;Image Name="csi_needle_2.bmp"&gt;
    &lt;Axis X="0" Y="1.5"/&gt;
    &lt;/Image&gt;
   &lt;Rotate&gt;
        &lt;Value Minimum="-1" Maximum="1"&gt;(A:NAV GSI:2, number) 140 /&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="-1" Degrees="-25"/&gt;
          &lt;Item Value="0" Degrees="0"/&gt;
          &lt;Item Value="1" Degrees="25"/&gt;
        &lt;/Nonlinearity&gt;
       &lt;Delay PixelsPerSecond="10"/&gt;
     &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="126" Y="62"/&gt;
    &lt;Image Name="csi_needle_1.bmp"&gt;
    &lt;Axis X="1.5" Y="0"/&gt;
    &lt;/Image&gt;
   &lt;Rotate&gt;
        &lt;Value Minimum="-1" Maximum="1"&gt;(A:NAV CDI:2, number) 140 /&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="1" Degrees="-25"/&gt;
          &lt;Item Value="0" Degrees="0"/&gt;
          &lt;Item Value="-1" Degrees="25"/&gt;
        &lt;/Nonlinearity&gt;
       &lt;Delay PixelsPerSecond="10"/&gt;
     &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="115" Y="24"/&gt;
    &lt;Image Name="csi_m.bmp"/&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
  &lt;Tooltip&gt;Course Select Indicator (%((A:NAV2 OBS,degrees))%!d!&amp;#176;)&lt;/Tooltip&gt;
    &lt;Area Left="206" Top="205" Width="40" Height="40"&gt;
      &lt;Help ID="HELPID_GAUGE_VOR2_OBS2"/&gt;
      &lt;Area Right="20"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="VOR2_OBI_DEC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
      &lt;Area Left="20"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="VOR2_OBI_INC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
    &lt;/Area&gt;
   &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>CYC.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="a_cyc_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterDcBus,bool) 1 == (A:Rotor RPM PCT:1, percent) 95 &amp;lt; &amp;amp;&amp;amp; if{ (A:YOKE X POSITION,percent) (A:YOKE Y POSITION,percent) -7 max 7 min } &lt;/Value&gt;
       &lt;Case Value="-7"&gt;
       &lt;Image Name="a_cyc_on.bmp" Bright="Yes"/&gt;
       &lt;/Case&gt;
       &lt;Case Value="7"&gt;
       &lt;Image Name="a_cyc_on.bmp" Bright="Yes"/&gt;
       &lt;/Case&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:Cyctest,bool) } &lt;/Value&gt;
       &lt;Case Value="1"&gt;
       &lt;Image Name="a_cyc_on.bmp" Bright="Yes"/&gt;
       &lt;/Case&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;

&lt;Mouse&gt;
 &lt;Tooltip ID=""&gt;Cyc Control&lt;/Tooltip&gt;
  &lt;Cursor Type="Hand"/&gt;
   &lt;Click Kind="LeftSingle+Leave"&gt;
	(M:Event) 'LeftSingle' scmp 0 == (L:Cyctest,bool) 0 == and if{ 1 (&amp;gt;L:Cyctest,bool) }
    (M:Event) 'Leave' scmp 0 == (L:Cyctest,bool) 1 == and if{ 0 (&amp;gt;L:Cyctest,bool) }			
   &lt;/Click&gt;
&lt;/Mouse&gt;
&lt;/Gauge&gt;



 
</pre><br/><hr/><br/><h1>C_MAST.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="chip_Mast" Version="1.0"&gt;
 
&lt;Element&gt;
  &lt;Select&gt;
    &lt;Value&gt;(L:chip mast, bool)&lt;/Value&gt;
      &lt;Case Value="0"&gt;
         &lt;Image Name="chip.bmp"/&gt;
       &lt;/Case&gt;
       &lt;Case Value="1"&gt;
          &lt;Image Name="chip_test.bmp"/&gt;
       &lt;/Case&gt;
     &lt;/Select&gt;
&lt;/Element&gt;

  &lt;Mouse&gt;     
        &lt;Tooltip&gt;Chip Mastil&lt;/Tooltip&gt;
        &lt;Cursor Type="Hand"/&gt;
	  &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:chip mast, bool) 0 == and if{ 1 (&amp;gt;L:chip mast, bool) }
  		(M:Event) 'Leave' scmp 0 == (L:chip mast, bool) 1 == and if{ 0 (&amp;gt;L:chip mast, bool) }			
	    &lt;/Click&gt;
   &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>C_PLNTY.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="chip_plnty" Version="1.0"&gt;
 
&lt;Element&gt;
  &lt;Select&gt;
    &lt;Value&gt;(L:chip plnty, bool)&lt;/Value&gt;
      &lt;Case Value="0"&gt;
         &lt;Image Name="chip.bmp"/&gt;
       &lt;/Case&gt;
       &lt;Case Value="1"&gt;
          &lt;Image Name="chip_test.bmp"/&gt;
       &lt;/Case&gt;
     &lt;/Select&gt;
&lt;/Element&gt;

  &lt;Mouse&gt;     
        &lt;Cursor Type="Hand"/&gt;
        &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:chip plnty, bool) 0 == and if{ 1 (&amp;gt;L:chip plnty, bool) }
  		(M:Event) 'Leave' scmp 0 == (L:chip plnty, bool) 1 == and if{ 0 (&amp;gt;L:chip plnty, bool) }			
	  &lt;/Click&gt;
   &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>C_SUMP.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="chip_sump" Version="1.0"&gt;
 
&lt;Element&gt;
  &lt;Select&gt;
    &lt;Value&gt;(L:chip sump, bool)&lt;/Value&gt;
      &lt;Case Value="0"&gt;
         &lt;Image Name="chip.bmp"/&gt;
       &lt;/Case&gt;
       &lt;Case Value="1"&gt;
          &lt;Image Name="chip_test.bmp"/&gt;
       &lt;/Case&gt;
     &lt;/Select&gt;
&lt;/Element&gt;

  &lt;Mouse&gt;     
        &lt;Cursor Type="Hand"/&gt;
        &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:chip sump, bool) 0 == and if{ 1 (&amp;gt;L:chip sump, bool) }
  		(M:Event) 'Leave' scmp 0 == (L:chip sump, bool) 1 == and if{ 0 (&amp;gt;L:chip sump, bool) }			
	  &lt;/Click&gt;
   &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>DAFCS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="DAFCS" Version="1.0"&gt;
 &lt;Image Name="dafcs_background.bmp"/&gt;


  &lt;Element&gt;
   &lt;Visible&gt;(L:Dafcssel,enum) 1 ==&lt;/Visible&gt;
  &lt;Element&gt;
    &lt;Position X="66" Y="15"/&gt;
     &lt;Text X="72" Y="19" Length="4" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((L:pitotcovers,bool) 0 == if{ (A:AIRSPEED TRUE,Knots) })%!4d!&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;Element&gt;
    &lt;Position X="46" Y="14"/&gt;
     &lt;Text X="20" Y="10" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;KT&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:Dafcssel,enum) 2 ==&lt;/Visible&gt;
  &lt;Element&gt;
     &lt;Position X="66" Y="15"/&gt;
     &lt;Text X="72" Y="19" Length="4" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((L:pitotcovers,bool) 0 == if{ (A:Vertical speed,feet per minute) })%!4d!&lt;/String&gt;
	 &lt;/Text&gt;
	 &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
    &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;Element&gt;
    &lt;Position X="48" Y="14"/&gt;
     &lt;Text X="20" Y="10" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;FT&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;Element&gt;
    &lt;Position X="46" Y="25"/&gt;
     &lt;Text X="18" Y="10" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;MIN&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt; 
   &lt;Area Left="119" Top="45" Width="24" Height="24"&gt;
    &lt;Cursor Type="Hand"/&gt;
     &lt;Click&gt;(L:Dafcssel,enum) ++ d 2 &amp;gt; if{ 0 } (&amp;gt;L:Dafcssel,enum)&lt;/Click&gt;  
   &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>DME.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="DME" Version="1.0"&gt;
 &lt;Image Name="dme_background.bmp"/&gt;

 &lt;Element&gt;
   &lt;Visible&gt;(L:Swdme,Enum) 0 &amp;gt;&lt;/Visible&gt;
  &lt;Element&gt;
    &lt;Position X="30" Y="10"/&gt;
     &lt;Text X="185" Y="24" Length="12" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((L:Swdme,Enum) 2 ==)%{if}%((A:NAV2 DME, nmiles) s0 (A:NAV2 DMESPEED, knots) s1)%{else}%((A:NAV1 DME, nmiles) s0 (A:NAV1 DMESPEED, knots) s1)%{end}%(l0 0 &amp;gt;=)%{if}%(l0 9999 min d 99 &amp;lt;=)%{if}%!4.1f! %{else}%!3d!%{end} %(l1 9999 min)%!03d! %(l0 l1 / 60 * 99 min)%!02d! min%{else}---- ---- --%{end})"&lt;/String&gt;
	 &lt;/Text&gt;
	 &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
    &lt;/Failures&gt;
  &lt;/Element&gt; 
  &lt;Element&gt;
    &lt;Position X="84" Y="32"/&gt;
     &lt;Text X="26" Y="12" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;NM&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;Element&gt;
    &lt;Position X="161" Y="32"/&gt;
     &lt;Text X="26" Y="12" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;KT&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  &lt;Element&gt;
    &lt;Position X="210" Y="32"/&gt;
     &lt;Text X="26" Y="12" Length="3" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;MIN&lt;/String&gt;
	 &lt;/Text&gt;
     &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
 &lt;/Element&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>FUELP1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="FUELP1" Version="1.0"&gt;
 &lt;Image Name="fuelp_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="fuelp_needle.bmp" PointsTo="North"&gt;
      &lt;Axis X="23" Y="54"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:MasterACDC, bool) 1 == if{ (L:fuelp1,psi) }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="135" Y="141"/&gt;
          &lt;Item Value="10" X="77" Y="158"/&gt;		  
          &lt;Item Value="20" X="25" Y="118"/&gt;
          &lt;Item Value="30" X="27" Y="56"/&gt;
          &lt;Item Value="40" X="70" Y="22"/&gt;
          &lt;Item Value="50" X="125" Y="30"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="5"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
 
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 1 Fuel Pressure(%((L:MasterACDC, bool) 1 == if{ (L:fuelp1,psi) })%!d! PSI)&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>FUELP2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="FUELP2" Version="1.0"&gt;
 &lt;Image Name="fuelp_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="fuelp_needle.bmp" PointsTo="North"&gt;
      &lt;Axis X="23" Y="54"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:MasterACDC, bool) 1 == if{ (L:fuelp2,psi) }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="135" Y="141"/&gt;
          &lt;Item Value="10" X="77" Y="158"/&gt;		  
          &lt;Item Value="20" X="25" Y="118"/&gt;
          &lt;Item Value="30" X="27" Y="56"/&gt;
          &lt;Item Value="40" X="70" Y="22"/&gt;
          &lt;Item Value="50" X="125" Y="30"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="5"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
 
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 2 Fuel Pressure(%((L:MasterACDC, bool) 1 == if{ (L:fuelp2,psi) })%!d! PSI)&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>FUELQ.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="FUELQ" Version="1.0"&gt;
 &lt;Image Name="fuelq_background.bmp"/&gt;


  &lt;Element&gt;
    &lt;Position X="71" Y="76"/&gt;
    &lt;Image Name="fuelq_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="7" Y="8"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="2200"&gt;(L:MasterDcBus,bool) 1 == if{ (L:fuelq,pound) (L:fuelqtc,pound) + } els{ 0 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
		  &lt;Item Value="0" X="37" Y="111"/&gt;
		  &lt;Item Value="1000" X="26" Y="63"/&gt;
		  &lt;Item Value="2200" X="70" Y="27"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="108" Y="76"/&gt;
    &lt;Image Name="fuelq_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="7" Y="8"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="2200"&gt;(L:MasterDcBus,bool) 1 == if{ (L:fuelq,pound) (L:fuelqtc,pound) + } els{ 0 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="2200" X="109" Y="28"/&gt;
 	      &lt;Item Value="1000" X="153" Y="63"/&gt;
		  &lt;Item Value="0" X="141" Y="110"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:Digitstest,bool) 0 == &lt;/Visible&gt;
    &lt;Position X="59" Y="126"/&gt;
     &lt;Text X="58" Y="24" Length="4" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="#ffd44f" Bright="Yes"&gt;
       &lt;String&gt;%((L:fuelq,pound))%!4d!&lt;/String&gt;
	 &lt;/Text&gt;
	 &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
     &lt;/Failures&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:Digitstest,bool) 1 == &lt;/Visible&gt;
    &lt;Position X="59" Y="126"/&gt;
     &lt;Text X="58" Y="24" Length="4" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="#ffd44f" Bright="Yes"&gt;
       &lt;String&gt;%((L:fuelqt,enum))%!4d!&lt;/String&gt;
	 &lt;/Text&gt;
	 &lt;Failures&gt;
    	&lt;SYSTEM_ELECTRICAL_PANELS Action="NoDraw"/&gt;
    &lt;/Failures&gt;
  &lt;/Element&gt;


&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>GEARBOX.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="GEARBOX" Version="1.0"&gt;
 &lt;Image Name="gearbox_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:GboxT, celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:Gbox, psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="100" Degrees="-72"/&gt;		
          &lt;Item Value="80" Degrees="-44"/&gt;		
          &lt;Item Value="60" Degrees="-14"/&gt;
          &lt;Item Value="40" Degrees="15"/&gt;
          &lt;Item Value="20" Degrees="47"/&gt;		  		  		
		  &lt;Item Value="0" Degrees="74"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="10"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Transmission Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:GboxT, celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Transmission Oil Pressure(%((L:Gbox, psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>HOURMTR.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Hourmtr" Version="1.0"&gt;
  &lt;Image Name="hourmtr.bmp"/&gt;

&lt;Element&gt;
  &lt;Position X="40" Y="71"/&gt;
   &lt;MaskImage Name="win_hmeter.bmp"&gt;
    &lt;Axis X="41" Y="7"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="hour1.bmp"&gt;
    &lt;Nonlinearity&gt;
     &lt;Item Value="0" X="0" Y="7"/&gt;
     &lt;Item Value="100" X="0" Y="90"/&gt;     
    &lt;/Nonlinearity&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:GENERAL ENG ELAPSED TIME:1,minutes) 100 %&lt;/Value&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Position X="40" Y="71"/&gt;
   &lt;MaskImage Name="win_hmeter.bmp"&gt;
    &lt;Axis X="31" Y="7"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="hour10.bmp"&gt;
    &lt;Nonlinearity&gt;
     &lt;Item Value="0" X="0" Y="7"/&gt;
     &lt;Item Value="10" X="0" Y="147"/&gt;     
    &lt;/Nonlinearity&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:GENERAL ENG ELAPSED TIME:1,hours) 10 %&lt;/Value&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Position X="40" Y="71"/&gt;
   &lt;MaskImage Name="win_hmeter.bmp"&gt;
    &lt;Axis X="21" Y="7"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="hour10.bmp"&gt;
    &lt;Nonlinearity&gt;
     &lt;Item Value="0" X="0" Y="7"/&gt;
     &lt;Item Value="100" X="0" Y="147"/&gt;     
    &lt;/Nonlinearity&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:GENERAL ENG ELAPSED TIME:1,hours) 100 %&lt;/Value&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Position X="40" Y="71"/&gt;
   &lt;MaskImage Name="win_hmeter.bmp"&gt;
    &lt;Axis X="11" Y="7"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="hour10.bmp"&gt;
    &lt;Nonlinearity&gt;
     &lt;Item Value="0" X="0" Y="7"/&gt;
     &lt;Item Value="1000" X="0" Y="147"/&gt;     
    &lt;/Nonlinearity&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:GENERAL ENG ELAPSED TIME:1,hours) 1000 %&lt;/Value&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Position X="40" Y="71"/&gt;
   &lt;MaskImage Name="win_hmeter.bmp"&gt;
    &lt;Axis X="1" Y="7"/&gt;
   &lt;/MaskImage&gt;
   &lt;Image Name="hour10.bmp"&gt;
    &lt;Nonlinearity&gt;
     &lt;Item Value="0" X="0" Y="7"/&gt;
     &lt;Item Value="10000" X="0" Y="147"/&gt;     
    &lt;/Nonlinearity&gt;
   &lt;/Image&gt;
   &lt;Shift&gt;
    &lt;Value&gt;(A:GENERAL ENG ELAPSED TIME:1,hours) 10000 %&lt;/Value&gt;
   &lt;/Shift&gt;
&lt;/Element&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>HSI.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="HSI" Version="1.0"&gt;
 &lt;Image Name="hsi_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="155" Y="141"/&gt;
    &lt;Image Name="hsi_card.bmp"&gt;
      &lt;Axis X="90" Y="90"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(A:Plane heading degrees gyro,radians) /-/ &lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="155" Y="141"/&gt;
    &lt;Image Name="hsi_scale_card.bmp" PointsTo="North"&gt;
       &lt;Axis X="60" Y="80"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
        &lt;Value&gt;(A:NAV1 OBS,degrees) d (A:Plane heading degrees gyro,degrees) 90 + - dgrd&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
   &lt;Element&gt;
    &lt;Position X="155" Y="141"/&gt;
     &lt;Select&gt;
        &lt;Value&gt;(A:HSI TF flags, ENUM)&lt;/Value&gt;
        &lt;Case Value="1"&gt;
           &lt;Image Name="hsi_to.bmp" PointsTo="North"&gt;
              &lt;Axis X="15" Y="32"/&gt;
           &lt;/Image&gt;
        &lt;/Case&gt;
        &lt;Case Value="2"&gt;
           &lt;Image Name="hsi_from.bmp" PointsTo="North"&gt;
              &lt;Axis X="15" Y="-16"/&gt;
           &lt;/Image&gt;
        &lt;/Case&gt;
     &lt;/Select&gt;
     &lt;Rotate&gt;
        &lt;Value&gt;(A:NAV1 OBS,degrees) d (A:Plane heading degrees gyro,degrees) 90 + - dgrd&lt;/Value&gt;
     &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="155" Y="141"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(A:HSI CDI needle valid,bool)&lt;/Value&gt;
       &lt;Case Value="0"&gt;
          &lt;Image Name="hsi_nav_flag.bmp" PointsTo="North"&gt;
             &lt;Axis X="18" Y="43"/&gt;
         &lt;/Image&gt;
       &lt;/Case&gt;
    &lt;/Select&gt;
    &lt;Rotate&gt;
        &lt;Value&gt;(A:NAV1 OBS,degrees) d (A:Plane heading degrees gyro,degrees) 90 + - dgrd&lt;/Value&gt;
     &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="23" Y="124"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(A:HSI GSI needle valid,bool)&lt;/Value&gt;
       &lt;Case Value="0"&gt;
          &lt;Image Name="hsi_gs_flag.bmp"/&gt;
       &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="20" Y="141"/&gt;
    &lt;Image Name="hsi_gs_pointer.bmp"&gt;
       &lt;Axis X="0" Y="9"/&gt;
    &lt;/Image&gt;
    &lt;Shift&gt;
       &lt;Value Minimum="-90" Maximum="90"&gt;(A:HSI GSI needle valid, bool) if{ (A:HSI GSI needle, number) } els{ 0 }&lt;/Value&gt;
       &lt;Scale Y="0.48"/&gt;
       &lt;Delay PixelsPerSecond="20"/&gt;
    &lt;/Shift&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="155" Y="141"/&gt;
    &lt;Image Name="hsi_needle.bmp" PointsTo="North"&gt;            
      &lt;Axis X="1" Y="49"/&gt;
    &lt;/Image&gt;
    &lt;Shift&gt;
       &lt;Value&gt;(A:NAV1 HAS NAV, bool) if{ (A:HSI CDI needle, number)  } els{ 0 }&lt;/Value&gt;
       &lt;Scale Y="0.30"/&gt;  
    &lt;/Shift&gt;
    &lt;Rotate&gt;
       &lt;Value&gt;(A:NAV1 OBS,degrees) d (A:Plane heading degrees gyro,degrees) 90 + - dgrd&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="155" Y="141"/&gt;
      &lt;Image Name="hsi_nav_2.bmp"&gt;
         &lt;Axis X="10" Y="105"/&gt;
      &lt;/Image&gt;
      &lt;Rotate&gt;
         &lt;Value&gt;(L:MasterACDC, bool) if{ (A:ADF1 Radial,radians) } els{ 1.570 }&lt;/Value&gt;
         &lt;Delay DegreesPerSecond="180"/&gt;
      &lt;/Rotate&gt;
   &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="155" Y="141"/&gt;
      &lt;Image Name="hsi_nav_1.bmp"&gt;
         &lt;Axis X="12" Y="104"/&gt;
      &lt;/Image&gt;
      &lt;Rotate&gt;
         &lt;Value&gt;(A:NAV1 radial, radians) (A:Plane heading degrees gyro, radians) - pi + &lt;/Value&gt;
         &lt;Delay DegreesPerSecond="180"/&gt;
      &lt;/Rotate&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
   &lt;Position X="155" Y="141"/&gt;
     &lt;Image Name="hsi_heading.bmp" PointsTo="North"&gt;
       &lt;Axis X="7" Y="95"/&gt;     
     &lt;/Image&gt;
     &lt;Rotate&gt;
       &lt;Value&gt;(A:Autopilot heading lock dir,radians) (A:Plane heading degrees gyro,radians) - &lt;/Value&gt;
     &lt;/Rotate&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="277" Y="105"/&gt;
    &lt;Select&gt;
       &lt;Value&gt;(L:MasterACDC, bool)&lt;/Value&gt;
       &lt;Case Value="0"&gt;
          &lt;Image Name="hsi_off.bmp"/&gt;
       &lt;/Case&gt;
    &lt;/Select&gt;
 &lt;/Element&gt;
 
 &lt;Element&gt;
   &lt;Position X="342" Y="104"/&gt;
    &lt;Image Name="hsi_heading_set.bmp"&gt;
      &lt;Axis X="25" Y="25"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
       &lt;Value&gt;(A:Autopilot heading lock dir,radians)&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="342" Y="179"/&gt;
    &lt;Image Name="hsi_course_set.bmp"&gt;
      &lt;Axis X="25" Y="25"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
       &lt;Value&gt;(A:NAV1 OBS,radians)&lt;/Value&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
   &lt;Element&gt;
      &lt;Position X="256" Y="63"/&gt;
     &lt;Text X="33" Y="14" Length="4" Font="Gill Sans MT" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="white"&gt;
       &lt;String&gt;%((A:NAV1 OBS,degrees))%!003d!&lt;/String&gt;
	 &lt;/Text&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="140" Y="13"/&gt;
       &lt;Image Name="hsi_aircraft.bmp"/&gt;
 &lt;/Element&gt;
  
  &lt;Mouse&gt;
    &lt;Tooltip ID=""&gt;Horizontal Situation Indicador&lt;/Tooltip&gt;

    &lt;Area Left="317" Top="153" Width="50" Height="50"&gt;
      &lt;Area Right="25"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="VOR1_OBI_DEC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
      &lt;Area Left="25"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="VOR1_OBI_INC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
     &lt;/Area&gt;

	&lt;Area Left="317" Top="79" Width="50" Height="50"&gt;
	&lt;Tooltip&gt;(%((A:Autopilot heading lock dir,degrees) (A:Plane heading degrees gyro,degrees) - )%!d!&amp;#176;)&lt;/Tooltip&gt;
     &lt;Area Right="25"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="HEADING_BUG_DEC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
      &lt;Area Left="25"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="HEADING_BUG_INC" Repeat="Yes"/&gt;
      &lt;/Area&gt;
     &lt;/Area&gt;
  &lt;/Mouse&gt;

&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>HYDRE1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="HYDRE1" Version="1.0"&gt;
 &lt;Image Name="hydr_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:HYDRT,celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:HYDRS1,psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="1500" X="123" Y="39"/&gt;
          &lt;Item Value="1000" X="153" Y="68"/&gt;
 	      &lt;Item Value="500" X="153" Y="111"/&gt;
		  &lt;Item Value="0" X="120" Y="140"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="10"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Hydraulic System 1 Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:HYDRT,celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Hydraulic System 1 Oil Pressure(%((L:HYDRS1,psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>HYDRE2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="HYDRE2" Version="1.0"&gt;
 &lt;Image Name="hydr_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:HYDRT,celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:HYDRS2,psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="1500" X="123" Y="39"/&gt;
          &lt;Item Value="1000" X="153" Y="68"/&gt;
 	      &lt;Item Value="500" X="153" Y="111"/&gt;
		  &lt;Item Value="0" X="120" Y="140"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="10"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Hydraulic System 2 Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:HYDRT,celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Hydraulic System 2 Oil Pressure(%((L:HYDRS2,psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>ITTE1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="ITTE1" Version="1.0"&gt;
 &lt;Image Name="itt_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="RPM_needle1.bmp" PointsTo="North"&gt;
      &lt;Axis X="17" Y="60"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:ITTE1,celsius)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="139" Y="44"/&gt;
          &lt;Item Value="300" X="150" Y="57"/&gt;		  
          &lt;Item Value="400" X="158" Y="78"/&gt;
          &lt;Item Value="500" X="158" Y="102"/&gt;
          &lt;Item Value="600" X="150" Y="123"/&gt;
          &lt;Item Value="700" X="136" Y="141"/&gt;
          &lt;Item Value="800" X="50" Y="148"/&gt;
          &lt;Item Value="900" X="24" Y="66"/&gt;
 	      &lt;Item Value="1000" X="92" Y="20"/&gt;
		  &lt;Item Value="1100" X="110" Y="25"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="5"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
 
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 1 Inter Turbine Temperature (%((L:ITTE1,celsius))%!d!&amp;#176;C)&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>ITTE2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="ITTE2" Version="1.0"&gt;
 &lt;Image Name="itt_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="RPM_needle1.bmp" PointsTo="North"&gt;
      &lt;Axis X="17" Y="60"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:ITTE2,celsius)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="139" Y="44"/&gt;
          &lt;Item Value="300" X="150" Y="57"/&gt;		  
          &lt;Item Value="400" X="158" Y="78"/&gt;
          &lt;Item Value="500" X="158" Y="102"/&gt;
          &lt;Item Value="600" X="150" Y="123"/&gt;
          &lt;Item Value="700" X="136" Y="141"/&gt;
          &lt;Item Value="800" X="50" Y="148"/&gt;
          &lt;Item Value="900" X="24" Y="66"/&gt;
 	      &lt;Item Value="1000" X="92" Y="20"/&gt;
		  &lt;Item Value="1100" X="110" Y="25"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="5"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
 
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 2 Inter Turbine Temperature(%((L:ITTE2,celsius))%!d!&amp;#176;C)&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Marker.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Marker" Version="1.0"&gt;
 &lt;Image Name="marker_background.bmp"/&gt;
 
    &lt;Element&gt;
      &lt;Position X="62" Y="0"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus, bool) if{ (L:TestMarker,bool) || (A:Outer Marker,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="marker3.bmp" Bright="Yes" /&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;

   &lt;Element&gt;
      &lt;Position X="31" Y="0"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus, bool) if{ (L:TestMarker,bool) || (A:Middle Marker,bool) || }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="marker2.bmp" Bright="Yes" /&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;

   &lt;Element&gt;
      &lt;Position X="0" Y="0"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus, bool) if{ (L:TestMarker,bool) || (A:Inner Marker,bool) || }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="marker1.bmp" Bright="Yes" /&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;

 &lt;Mouse&gt;
  &lt;Area Left="27" Top="23" Width="7" Height="7"&gt;
   &lt;Tooltip ID=""&gt;Marker Test&lt;/Tooltip&gt;
   &lt;Cursor Type="Hand"/&gt;
   &lt;Click Kind="LeftSingle+Leave"&gt;
	(M:Event) 'LeftSingle' scmp 0 == (L:TestMarker,bool) 0 == and if{ 1 (&amp;gt;L:TestMarker,bool) }
    (M:Event) 'Leave' scmp 0 == (L:TestMarker,bool) 1 == and if{ 0 (&amp;gt;L:TestMarker,bool) }			
   &lt;/Click&gt;
  &lt;/Area&gt;
 &lt;/Mouse&gt;
&lt;/Gauge&gt;

</pre><br/><hr/><br/><h1>MC.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="A_MASTERC" Version="1.0"&gt;
 &lt;Image Name="mc_background.bmp"/&gt;

   &lt;Element&gt;
    &lt;Position X="14" Y="24"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:OILE1,psi) 50 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="24"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:OILE2,psi) 50 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="61"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="61"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="98"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwvalveEng1,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="98"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwvalveEng2,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwboostpuEng1,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwboostpuEng2,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwfueltransengA,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca5.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwfueltransengB,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca6.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:Swbatta,bool) (L:Swbattb,bool) 1 == &amp;amp;&amp;amp; || (L:TestMC,enum) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca7.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
  &lt;Element&gt;
    &lt;Position X="561" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
 
  &lt;Element&gt;
    &lt;Position X="14" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (A:FUEL TANK CENTER LEVEL,percent) 9.2 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca8.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:Swfuelintcon,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf5.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="320"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="320"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwFuelxfeed,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cf6.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="14" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca10.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="561" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="24"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:CSepP1,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="24"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:CSepP2,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="61"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwGovA,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="61"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwGovB,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="98"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:CGenel,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="98"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:CGener,bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ce1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb5.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (A:Rotor Brake Active,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb6.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (A:Rotor Brake Active,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb6.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ce2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) ||  (L:Swinva, bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb7.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) ||  (L:Swinvb, bool) 0 == || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ce3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
  &lt;Element&gt;
    &lt;Position X="125" Y="320"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:SwHeater,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cb8.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="320"/&gt;
      &lt;Select&gt;
        &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:Door passenger l,percent) || (L:Door passenger r,percent) || (L:Door baggage,position) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ce4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="125" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="453" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="135"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:Gbox, psi) 40 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="172"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:XMSN,psi) 30 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cd1.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:GboxT, celsius) 0 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="209"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:XMSNT,celsius) 0 &amp;lt; || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cd2.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="246"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cd3.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:Sw hydsysA,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc5.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="283"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:Sw hydsysB,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cd4.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="320"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:ExternalPower,bool) || } }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cc6.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="320"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_cd5.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="234" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Element&gt;
    &lt;Position X="344" Y="357"/&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:TestMC,enum) 0 &amp;gt; }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="mc_ca9.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Mouse&gt;
   &lt;Area Left="324" Top="38" Width="20" Height="20"&gt;
	&lt;Tooltip&gt;Reset&lt;/Tooltip&gt;
       &lt;Cursor Type="Hand"/&gt;
	    &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:ResetMC,bool) 0 == and if{ 1 (&amp;gt;L:ResetMC,bool) }
  		(M:Event) 'Leave' scmp 0 == (L:ResetMC,bool) 1 == and if{ 0 (&amp;gt;L:ResetMC,bool) }			
	    &lt;/Click&gt;
       &lt;/Area&gt;
   &lt;/Mouse&gt;
      
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>NAV_GPS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="NAV_GPS" Version="1.0"&gt;
 &lt;Image Name="nav_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (A:GPS drives nav1,bool) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="nav_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
   &lt;Mouse&gt;
    &lt;Help ID="HELPID_GAUGE_NAV_GPS_SWITCH"/&gt;
    &lt;Cursor Type="Hand"/&gt;
    &lt;Click Event="TOGGLE_GPS_DRIVES_NAV1"/&gt;
   &lt;/Mouse&gt;

  &lt;Element&gt;
    &lt;Select&gt;
       &lt;Value&gt;
	    (L:Eng1N2,percent) 80 &amp;gt;= if{ (A:GENERAL ENG THROTTLE LEVER POSITION:1,percent) (&amp;gt;L:Eng1torque,percent) }
	    (L:Eng2N2,percent) 80 &amp;gt;= if{ (A:GENERAL ENG THROTTLE LEVER POSITION:1,percent) (&amp;gt;L:Eng2torque,percent) }
		(A:Eng2 Combustion,bool) (A:Indicated Altitude, feet) 4000 &amp;gt;= &amp;amp;&amp;amp; (L:RPM N1 E1,percent) 80 &amp;lt;= &amp;amp;&amp;amp; if{ 3 (&amp;gt;L:SynRPM1,percent) } els{ 0 (&amp;gt;L:SynRPM1,percent) }
		(A:Eng3 Combustion,bool) (A:Indicated Altitude, feet) 4000 &amp;gt;= &amp;amp;&amp;amp; (L:RPM N1 E2,percent) 80 &amp;lt;= &amp;amp;&amp;amp; if{ 3 (&amp;gt;L:SynRPM2,percent) } els{ 0 (&amp;gt;L:SynRPM2,percent) }
 	   &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
       &lt;Value&gt;
    	(A:Eng2 Combustion,bool) 1 == (L:RPM N1 E2,percent) 83 &amp;lt;= &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:OEIE1,bool) } els{ 0 (&amp;gt;L:OEIE1,bool) }
    	(A:Eng3 Combustion,bool) 1 == (L:RPM N1 E1,percent) 83 &amp;lt;= &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:OEIE2,bool) } els{ 0 (&amp;gt;L:OEIE2,bool) }
		(L:RPM N1 E1,percent) 72 &amp;gt;= (L:OEIE1,bool) 1 == &amp;amp;&amp;amp; if{ 10 (&amp;gt;L:OEIRPME1,percent) } els{ 0 (&amp;gt;L:OEIRPME1,percent) }
		(L:RPM N1 E2,percent) 72 &amp;gt;= (L:OEIE2,bool) 1 == &amp;amp;&amp;amp; if{ 10 (&amp;gt;L:OEIRPME2,percent) } els{ 0 (&amp;gt;L:OEIRPME2,percent) }
	   &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;   

  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	   (A:Turb eng2 N1, percent) (L:SynRPM1,percent) + (&amp;gt;L:GasN1E1,percent)
	   (L:GasN1E1,percent) 1.17 / (L:Eng1torque,percent) 6.21 / + (L:OEIRPME1,percent) + (&amp;gt;L:RPM N1 E1,percent)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	   (A:Turb eng3 N1, percent) (L:SynRPM2,percent) + (&amp;gt;L:GasN1E2,percent)
	   (L:GasN1E2,percent) 1.17 / (L:Eng2torque,percent) 6.21 / + (L:OEIRPME2,percent) + (&amp;gt;L:RPM N1 E2,percent)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
       (L:starteng,enum) 1 == if{ 200 (&amp;gt;L:ITTE1STR,celsius) } els{ 0 (&amp;gt;L:ITTE1STR,celsius) }
	   (A:Turb Eng2 ITT, celsius) + (L:Eng1torque,percent) 0.54 / + (L:ITTE1STR,celsius) + (L:OEIITTE1,celsius) + (&amp;gt;L:ITTE1,celsius)	  
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;  
  
  &lt;Element&gt;
    &lt;Select&gt;
       &lt;Value&gt;
		(L:OEIE1,bool) 1 == if{ 115 (&amp;gt;L:OEIITTE1,celsius) } els{ 0 (&amp;gt;L:OEIITTE1,celsius) }
		(L:OEIE2,bool) 1 == if{ 115 (&amp;gt;L:OEIITTE2,celsius) } els{ 0 (&amp;gt;L:OEIITTE2,celsius) }
	   &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
       (L:starteng,enum) - 1 == if{ 200 (&amp;gt;L:ITTE2STR,celsius) } els{ 0 (&amp;gt;L:ITTE2STR,celsius) }
	   (A:Turb Eng3 ITT, celsius) + (L:Eng2torque,percent) 0.54 / + (L:ITTE2STR,celsius) + (L:OEIITTE2,celsius) + (&amp;gt;L:ITTE2,celsius)	  
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
       (A:Turb eng2 N1, percent) s0 1 &amp;gt; if{ l0 95 / s1 100 * } (&amp;gt;L:OILE1,psi)  
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (A:General Eng2 Oil Temperature, celsius) (&amp;gt;L:OILE1T,celsius)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		 (A:Turb eng3 N1, percent) s0 1 &amp;gt; if{ l0 95 / s1 100 * } (&amp;gt;L:OILE2,psi)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (A:General Eng3 Oil Temperature,celsius) (&amp;gt;L:OILE2T,celsius)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (L:Sw hydsysA,bool) 0 == (A:Turb eng1 N1, percent) 10 &amp;gt;= &amp;amp;&amp;amp; if{ 1005 (&amp;gt;L:HYDRS1,psi) } els{ 0 (&amp;gt;L:HYDRS1,psi) }
        (L:Sw hydsysB,bool) 0 == (A:Turb eng1 N1, percent) 10 &amp;gt;= &amp;amp;&amp;amp; if{ 1005 (&amp;gt;L:HYDRS2,psi) } els{ 0 (&amp;gt;L:HYDRS2,psi) }
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
    
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	    34 (&amp;gt;L:EngHydTemp, celsius)
        (A:General Eng1 Oil Temperature,celsius) (L:EngHydTemp,celsius) - (&amp;gt;L:HYDRT,celsius)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		(A:Turb eng1 N1, percent) (&amp;gt;L:MGbox,percent)
		(L:MGbox,percent) s0 1 &amp;gt; if{ l0 95 / s1 100 * } (&amp;gt;L:Gbox,psi)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	  	(A:Eng2 Combustion,bool) (A:Eng3 Combustion,bool) || if{ 1 (&amp;gt;L:Rgbox,bool) } els{ 0 (&amp;gt;L:Rgbox,bool) }
		(A:General Eng1 Oil Temperature,celsius) (&amp;gt;L:GboxT,celsius)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	    (A:Turb eng1 N1, percent) (&amp;gt;L:Mxmsn,percent) }
		(L:Mxmsn,percent) s0 1 &amp;gt; if{ l0 105 / s1 85 * } (&amp;gt;L:XMSN,psi) 
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (A:General Eng1 Oil Temperature, celsius) (&amp;gt;L:XMSNT,celsius)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	    (L:SwboostpuEng1,bool) (L:SwvalveEng1,bool) 1 == &amp;amp;&amp;amp; if{ 14 (&amp;gt;L:fuelp1,psi) } els{ 0 (&amp;gt;L:fuelp1,psi) }
	    (L:SwboostpuEng2,bool) (L:SwvalveEng2,bool) 1 == &amp;amp;&amp;amp; if{ 14 (&amp;gt;L:fuelp2,psi) } els{ 0 (&amp;gt;L:fuelp2,psi) }
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
	    (L:Digitstest,bool) 1 == if{ 2200 (&amp;gt;L:fuelqtc,pound) } els{ 0 (&amp;gt;L:fuelqtc,pound) }
        (L:Digitstest,bool) 1 == if{ 8888 (&amp;gt;L:fuelqt,enum) } els{ 0 (&amp;gt;L:fuelqt,enum) }	  
	    (L:FuelQuantity, enum) -1 == if{ (A:FUEL TOTAL QUANTITY WEIGHT, pound) 1.5 / }		
	    (L:FuelQuantity, enum) 0 == if{ (A:FUEL TOTAL QUANTITY WEIGHT, pound) }
		(L:FuelQuantity, enum) 1 == if{ (A:FUEL TOTAL QUANTITY WEIGHT, pound) 2 / }
		(&amp;gt;L:fuelq,pound)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

 &lt;Element&gt;
   &lt;Select&gt;
    &lt;Value&gt;
     (L:RPM N1 E1,percent) 72 &amp;lt; (A:Eng3 Combustion,bool) 0 == &amp;amp;&amp;amp; (L:ENG1Stater,bool) 1 = &amp;amp;&amp;amp; if{ 280 (&amp;gt;L:OAmps1,amp) } els{ 0 (&amp;gt;L:OAmps1,amp) }
	 (L:CGenel,bool) 1 == if{ 75 (&amp;gt;L:CAmps1,amp) } els{ 0 (&amp;gt;L:CAmps1,amp) }
	 (L:CAmps1,amp) (L:OAmps1,amp) + (&amp;gt;L:Ampsg1,amp)
	&lt;/Value&gt;
   &lt;/Select&gt;
 &lt;/Element&gt;
 
 &lt;Element&gt;
   &lt;Select&gt;
    &lt;Value&gt;
	(L:RPM N1 E2,percent) 72 &amp;lt; (A:Eng2 Combustion,bool) 0 == &amp;amp;&amp;amp; (L:ENG2Stater,bool) 1 = &amp;amp;&amp;amp; if{ 280 (&amp;gt;L:OAmps2,amp) } els{ 0 (&amp;gt;L:OAmps2,amp) }
    (L:CGener,bool) 1 == if{ 75 (&amp;gt;L:CAmps2,amp) } els{ 0 (&amp;gt;L:CAmps2,amp) }
	(L:CAmps2,amp) (L:OAmps2,amp) + (&amp;gt;L:Ampsg2,amp)
	&lt;/Value&gt;
   &lt;/Select&gt;
 &lt;/Element&gt;
 
 &lt;Element&gt;
   &lt;Select&gt;
    &lt;Value&gt;
     (L:MasterDcBus,bool) 1 == (L:starteng,enum) 1 == &amp;amp;&amp;amp; (L:RPM N1 E1,percent) 58 &amp;lt;= &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:ENG1Stater,bool) } els{ 0 (&amp;gt;L:ENG1Stater,bool) }
     (L:MasterDcBus,bool) 1 == (L:starteng,enum) -1 == &amp;amp;&amp;amp; (L:RPM N1 E2,percent) 58 &amp;lt;= &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:ENG2Stater,bool) } els{ 0 (&amp;gt;L:ENG2Stater,bool) }
	&lt;/Value&gt;
   &lt;/Select&gt;
 &lt;/Element&gt;
 
   &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (L:ENG1Stater,bool) if{ (A:GENERAL ENG STARTER:2,bool) ! if{ (&amp;gt;K:TOGGLE_STARTER2) } }
		(L:ENG1Stater,bool) ! if{ (A:GENERAL ENG STARTER:2,bool) if{ (&amp;gt;K:TOGGLE_STARTER2) } }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
        (L:ENG2Stater,bool) if{ (A:GENERAL ENG STARTER:3,bool) ! if{ (&amp;gt;K:TOGGLE_STARTER3) } }
		(L:ENG2Stater,bool) ! if{ (A:GENERAL ENG STARTER:3,bool) if{ (&amp;gt;K:TOGGLE_STARTER3) } }
		(L:ENG1Stater,bool) (A:Eng3 Combustion,bool) 0 == &amp;amp;&amp;amp; || (L:ENG2Stater,bool) (A:Eng2 Combustion,bool) 0 == &amp;amp;&amp;amp; || if{ 1 (&amp;gt;L:MStater,bool) } els{ 0 (&amp;gt;L:MStater,bool) } 
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;


  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		(L:MasterDcBus,bool) 1 == (L:Swinva, bool) 1 == &amp;amp;&amp;amp; if{ 115 (&amp;gt;L:VoltAC1,volt) } els{ 0 (&amp;gt;L:VoltAC1,volt) }
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		(L:MasterDcBus,bool) 1 == if{ 24 (&amp;gt;L:BVoltDC1,volt) } els{ 0 (&amp;gt;L:BVoltDC1,volt) }
		(L:Genmast,bool) 1 == if{ 4 (&amp;gt;L:GVoltDC1,volt) } els{ 0 (&amp;gt;L:GVoltDC1,volt) }
        (A:Eng3 Combustion,bool) 0 == (L:MStater,bool) 1 == &amp;amp;&amp;amp; if{ 6 (&amp;gt;L:OVoltDC1,volt) } els{ 0 (&amp;gt;L:OVoltDC1,volt) }
		(L:BVoltDC1,volt) (L:GVoltDC1,volt) + (L:OVoltDC1,volt) - (&amp;gt;L:VoltDC1,volt)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		(L:MasterDcBus,bool) 1 == (L:Swinvb, bool) 1 == &amp;amp;&amp;amp; if{ 115 (&amp;gt;L:VoltAC2,volt) } els{ 0 (&amp;gt;L:VoltAC2,volt) }
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
      &lt;Value&gt;
		(L:MasterDcBus,bool) 1 == if{ 24 (&amp;gt;L:BVoltDC2,volt) } els{ 0 (&amp;gt;L:BVoltDC2,volt) }
		(L:Genmast,bool) 1 == if{ 4 (&amp;gt;L:GVoltDC2,volt) } els{ 0 (&amp;gt;L:GVoltDC2,volt) }
        (A:Eng2 Combustion,bool) 0 == (L:MStater,bool) 1 == &amp;amp;&amp;amp; if{ 6 (&amp;gt;L:OVoltDC2,volt) } els{ 0 (&amp;gt;L:OVoltDC2,volt) }
		(L:BVoltDC2,volt) (L:GVoltDC2,volt) + (L:OVoltDC2,volt) - (&amp;gt;L:VoltDC2,volt)
	  &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
	   (A:Eng2 Combustion,bool) if{ 58 (&amp;gt;L:Eng1N2,percent) } els{ 0 (&amp;gt;L:Eng1N2,percent) }
	   (A:Eng2 Combustion,bool) (A:Eng Rotor Rpm,percent) 98 &amp;gt; &amp;amp;&amp;amp; if{ 5 (&amp;gt;L:GovRPM1,percent) } els{ 0 (&amp;gt;L:GovRPM1,percent) }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;(A:Eng2 Combustion,bool) if{ (L:Eng1N2,percent) (L:throgas1,percent) 2.58 / + (L:GovRPM1,percent) + } (&amp;gt;L:Eng1N2,percent)&lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
	   (A:Eng3 Combustion,bool) if{ 58 (&amp;gt;L:Eng2N2,percent) } els{ 0 (&amp;gt;L:Eng2N2,percent) }
	   (A:Eng3 Combustion,bool) (A:Eng Rotor Rpm,percent) 98 &amp;gt; &amp;amp;&amp;amp; if{ 5 (&amp;gt;L:GovRPM2,percent) } els{ 0 (&amp;gt;L:GovRPM2,percent) }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;(A:Eng3 Combustion,bool) if{ (L:Eng2N2,percent) (L:throgas2,percent) 2.58 / + (L:GovRPM2,percent) + } (&amp;gt;L:Eng2N2,percent)&lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
		(L:Combustionm,bool) if{ 10 (&amp;gt;L:TRQrotor,percent) } els{ 0 (&amp;gt;L:TRQrotor,percent) }
		(L:Trotor,percent) 19 &amp;gt;= if{ (A:general eng throttle lever position:1,percent) (&amp;gt;L:torque,percent) }
		(L:Combustionm,bool) if{ (A:GENERAL ENG PROPELLER LEVER POSITION:1,percent) (&amp;gt;L:Powern2,percent) }
		(L:TRQrotor,percent) (L:Powern2,percent) 11 / + (L:torque,percent) + (&amp;gt;L:Trotor,percent)
     &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Select&gt;
     &lt;Value&gt;
		(A:Eng2 Combustion,bool) if{ 2 (&amp;gt;L:TRQeng1,percent) } els{ 0 (&amp;gt;L:TRQeng1,percent) }
		(L:Eng1TQ,percent) 9 &amp;gt;= if{ (A:general eng throttle lever position:1,percent) (&amp;gt;L:E1torque,percent) }
        (A:GENERAL ENG PROPELLER LEVER POSITION:2,percent) (&amp;gt;L:Powern2E1,percent)
		(L:RPM N1 E1,percent) 72 &amp;gt;= (L:OEIE1,bool) 1 == &amp;amp;&amp;amp; if{ 20 (&amp;gt;L:OEITRQeng1,percent) } els{ 0 (&amp;gt;L:OEITRQeng1,percent) }		
		(L:TRQeng1,percent) (L:Powern2E1,percent) 12.5 / + (L:E1torque,percent) 1.38 / + (L:OEITRQeng1,percent) + (&amp;gt;L:Eng1TQ,percent)
	 &lt;/Value&gt;
   &lt;/Select&gt;   
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Select&gt;
     &lt;Value&gt;
		(A:Eng3 Combustion,bool) if{ 2 (&amp;gt;L:TRQeng2,percent) } els{ 0 (&amp;gt;L:TRQeng2,percent) }
		(L:Eng2TQ,percent) 9 &amp;gt;= if{ (A:general eng throttle lever position:1,percent) (&amp;gt;L:E2torque,percent) }
        (A:GENERAL ENG PROPELLER LEVER POSITION:3,percent) (&amp;gt;L:Powern2E2,percent)
		(L:RPM N1 E2,percent) 72 &amp;gt;= (L:OEIE2,bool) 1 == &amp;amp;&amp;amp; if{ 20 (&amp;gt;L:OEITRQeng2,percent) } els{ 0 (&amp;gt;L:OEITRQeng2,percent) }	
		(L:TRQeng2,percent) (L:Powern2E2,percent) 12.5 / + (L:E2torque,percent) 1.38 / + (L:OEITRQeng2,percent) + (&amp;gt;L:Eng2TQ,percent)
	 &lt;/Value&gt;
   &lt;/Select&gt;   
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Select&gt;
     &lt;Value&gt;
       (L:MasterDcBus,bool) (L:stbatt,bool) 1 == &amp;amp;&amp;amp; (L:Swstbyatt,bool) 1 == &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:Masterstbatt,bool) } els{ 0 (&amp;gt;L:Masterstbatt,bool) }
	 &lt;/Value&gt;
   &lt;/Select&gt;   
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Select&gt;
     &lt;Value&gt;
       (L:MasterACDC, bool) 1 == (A:NAV HAS GLIDE SLOPE:1,bool) 0 == &amp;amp;&amp;amp; if{ 198 (&amp;gt;L:Mlocnav, number) } els{ 0 (&amp;gt;L:Mlocnav, number) }
	   (L:MasterACDC, bool) 1 == (A:NAV HAS GLIDE SLOPE:1,bool) 0 == &amp;amp;&amp;amp; if{ -580 (&amp;gt;L:Mgsnav, number) } els{ 0 (&amp;gt;L:Mgsnav, number) }
	 &lt;/Value&gt;
   &lt;/Select&gt;   
  &lt;/Element&gt;
 
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
		(A:General eng2 throttle lever position, percent) (A:TURB ENG2 N1, percent) 50 &amp;gt; *
		(A:General eng3 throttle lever position, percent) (A:TURB ENG3 N1, percent) 50 &amp;gt; * max  
		(A:General eng1 throttle lever position, percent) == ! if{ (A:General eng2 throttle lever position, percent) (A:TURB ENG2 N1, percent) 50 &amp;gt; *
	    (A:General eng3 throttle lever position, percent) (A:TURB ENG3 N1, percent) 50 &amp;gt; * max 163.84 * (&amp;gt;K:PROP_PITCH1_SET) }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
 
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
        (A:GENERAL ENG PROPELLER LEVER POSITION:2,percent) (&amp;gt;L:throgas1,percent)
		(A:GENERAL ENG PROPELLER LEVER POSITION:3,percent) (&amp;gt;L:throgas2,percent)
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
  		(L:throgas1,percent) 100 / 16384 * (&amp;gt;K:THROTTLE2_SET)
		(L:throgas2,percent) 100 / 16384 * (&amp;gt;K:THROTTLE3_SET)
     &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

 &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (A:GENERAL ENG PROPELLER LEVER POSITION:2, percent) 3 &amp;lt;= if{ 1 (&amp;gt;L:FuelcutE1,bool) } els{ 0 (&amp;gt;L:FuelcutE1,bool) } 
	   (A:GENERAL ENG PROPELLER LEVER POSITION:3, percent) 3 &amp;lt;= if{ 1 (&amp;gt;L:FuelcutE2,bool) } els{ 0 (&amp;gt;L:FuelcutE2,bool) }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;

   &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (L:SwvalveEng1,bool) 0 == || (L:FuelcutE1,bool) 1 == || (L:firethandl,bool) 1 == || if{ 0 (&amp;gt;L:MvalveEng1,bool) } els{ 1 (&amp;gt;L:MvalveEng1,bool) }
       (L:SwvalveEng2,bool) 0 == || (L:FuelcutE2,bool) 1 == || (L:firethandr,bool) 1 == || if{ 0 (&amp;gt;L:MvalveEng2,bool) } els{ 1 (&amp;gt;L:MvalveEng2,bool) }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (L:MvalveEng1,bool) if{ (A:GENERAL ENG FUEL VALVE:2,bool) ! if{ (&amp;gt;K:TOGGLE_FUEL_VALVE_ENG2) } } 
	   (L:MvalveEng1,bool) ! if{ (A:GENERAL ENG FUEL VALVE:2,bool) if{ (&amp;gt;K:TOGGLE_FUEL_VALVE_ENG2) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (L:MvalveEng2,bool) if{ (A:GENERAL ENG FUEL VALVE:3,bool) ! if{ (&amp;gt;K:TOGGLE_FUEL_VALVE_ENG3) } } 
	   (L:MvalveEng2,bool) ! if{ (A:GENERAL ENG FUEL VALVE:3,bool) if{ (&amp;gt;K:TOGGLE_FUEL_VALVE_ENG3) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
     &lt;Value&gt;
	 	(A:Eng2 Combustion,bool) || (A:Eng3 Combustion,bool) || if{ 1 (&amp;gt;L:Combustionm,bool) } els{ 0 (&amp;gt;L:Combustionm,bool) }
		(L:Combustionm,bool) if{ (&amp;gt;K:MIXTURE1_RICH) } els{ (&amp;gt;K:MIXTURE1_LEAN) }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	 &lt;Value&gt;
	   (L:RPM N1 E1,percent) 55 &amp;gt; if{ 1 (&amp;gt;L:SepP1,bool) } els{ 0 (&amp;gt;L:SepP1,bool) }
       (L:RPM N1 E2,percent) 55 &amp;gt; if{ 1 (&amp;gt;L:SepP2,bool) } els{ 0 (&amp;gt;L:SepP2,bool) }
	 &lt;/Value&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
		(L:Swposition,bool) if{ (A:LIGHT NAV,bool) ! if{ (&amp;gt;K:TOGGLE_NAV_LIGHTS) } } 
		(L:Swposition,bool) ! if{ (A:LIGHT NAV,bool) if{ (&amp;gt;K:TOGGLE_NAV_LIGHTS) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
		(L:Swanticoll,bool) if{ (A:LIGHT BEACON,bool) ! if{ (&amp;gt;K:TOGGLE_BEACON_LIGHTS) } } 
		(L:Swanticoll,bool) ! if{ (A:LIGHT BEACON,bool) if{ (&amp;gt;K:TOGGLE_BEACON_LIGHTS) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	  (L:Swbatta,bool) || (L:Swbattb,bool) || (L:ExternalPower,bool) || if{ (A:ELECTRICAL MASTER BATTERY,bool) ! if{ (&amp;gt;K:TOGGLE_MASTER_BATTERY) } } 
	  (L:Swbatta,bool) ! (L:Swbattb,bool) ! &amp;amp;&amp;amp; (L:ExternalPower,bool) ! &amp;amp;&amp;amp; if{ (A:ELECTRICAL MASTER BATTERY,bool) if{ (&amp;gt;K:TOGGLE_MASTER_BATTERY) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (L:SwpartsepA,bool) || (L:SepP1,bool) == 0 || if{ 1 (&amp;gt;L:CSepP1,bool) } els{ 0 (&amp;gt;L:CSepP1,bool) }
	   (L:SwpartsepB,bool) || (L:SepP2,bool) == 0 || if{ 1 (&amp;gt;L:CSepP2,bool) } els{ 0 (&amp;gt;L:CSepP2,bool) } 
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	   (L:CGenel,bool) 1 == (L:CGener,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&amp;gt;L:Swbatta,bool) } 
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	    (L:Genmast,bool) if{ (A:GENERAL ENG GENERATOR SWITCH:1,bool) ! if{ (&amp;gt;K:TOGGLE_MASTER_ALTERNATOR) } }
		(L:Genmast,bool) ! if{ (A:GENERAL ENG GENERATOR SWITCH:1,bool) if{ (&amp;gt;K:TOGGLE_MASTER_ALTERNATOR) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
	    (L:MasterACDC,bool) if{ (A:AVIONICS MASTER SWITCH,bool) ! if{ (&amp;gt;K:TOGGLE_AVIONICS_MASTER) } }
		(L:MasterACDC,bool) ! if{ (A:AVIONICS MASTER SWITCH,bool) if{ (&amp;gt;K:TOGGLE_AVIONICS_MASTER) } }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt; 
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
		(L:Genel,bool) 1 == (A:Eng2 Combustion,bool) 1 == &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:CGenel,bool) } els{ 0 (&amp;gt;L:CGenel,bool) }
		(L:Gener,bool) 1 == (A:Eng3 Combustion,bool) 1 == &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:CGener,bool) } els{ 0 (&amp;gt;L:CGener,bool) }
		(L:CGenel,bool) || (L:CGener,bool) || if{ 1 (&amp;gt;L:Genmast,bool) } els{ 0 (&amp;gt;L:Genmast,bool) }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
		(L:Swbatta,bool) || (L:Swbattb,bool) || (L:Genmast,bool) || (L:ExternalPower,bool) || if{ 1 (&amp;gt;L:MasterDcBus,bool) } els{ 0 (&amp;gt;L:MasterDcBus,bool) }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Select&gt;
	  &lt;Value&gt;
		(L:Swinva, bool) || (L:Swinvb, bool) || if{ 1 (&amp;gt;L:ACBus, bool) } els{ 0 (&amp;gt;L:ACBus, bool) }
		(L:ACBus, bool) (L:MasterDcBus, bool) 1 == &amp;amp;&amp;amp; if{ 1 (&amp;gt;L:MasterACDC, bool) } els{ 0 (&amp;gt;L:MasterACDC, bool) }
	  &lt;/Value&gt;
	&lt;/Select&gt;
  &lt;/Element&gt;     
   
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>OAT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="OAT" Version="1.0"&gt;
 &lt;Image Name="oat_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="130" Y="130"/&gt;
    &lt;Image Name="oat_needle.bmp" PointsTo="North"&gt;
      &lt;Axis X="10" Y="109"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
     &lt;Value Minimum="-70.0" Maximum="50.0"&gt;(A:Total Air Temperature,Celsius)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
         &lt;Item Value="-70" X="84" Y="232"/&gt;
         &lt;Item Value="0" X="174" Y="26"/&gt;
         &lt;Item Value="50" X="183" Y="227"/&gt;
      &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
    &lt;Tooltip ID="TOOLTIPTEXT_AMBIENT_TEMPERATURE_CELSIUS"/&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>OILE1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="OILE1" Version="1.0"&gt;
 &lt;Image Name="oil_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:OILE1T,celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:OILE1,psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="150" X="123" Y="39"/&gt;
          &lt;Item Value="100" X="153" Y="68"/&gt;
 	      &lt;Item Value="50" X="153" Y="111"/&gt;
		  &lt;Item Value="0" X="120" Y="140"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Engine 1 Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:OILE1T,celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Engine 1 Oil Pressure(%((L:OILE1,psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>OILE2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="OILE2" Version="1.0"&gt;
 &lt;Image Name="oil_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:OILE2T,celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:OILE2,psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="150" X="123" Y="39"/&gt;
          &lt;Item Value="100" X="153" Y="68"/&gt;
 	      &lt;Item Value="50" X="153" Y="111"/&gt;
		  &lt;Item Value="0" X="120" Y="140"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Engine 2 Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:OILE2T,celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Engine 2 Oil Pressure(%((L:OILE2,psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Panel_Control.xml</h1><pre>&lt;Gauge Name="Panel_Control" Version="1.0"&gt;
   &lt;Image Name="cntl_background.bmp"/&gt;

&lt;Element&gt;
 &lt;Position X="198" Y="51"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:pitotcovers,bool)&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_pitot.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="281" Y="0"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(A:SIM ON GROUND, bool) || if{ (L:ExternalPower,bool) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_gpu.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="213" Y="110"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(A:SIM ON GROUND, bool) || if{ (L:NoseDoor,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_nose.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="25" Y="240"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Copilotdoor,position)&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_copilot_on.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="25" Y="323"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger l,percent) 1 &amp;gt;&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_cargo_off.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="25" Y="313"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger l,percent) 1 &amp;gt; if{ (L:Door Cargo l,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_cargo_on_l.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt; 

&lt;Element&gt;
 &lt;Position X="9" Y="360"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger l,percent) 0 &amp;gt;&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_pass_l.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;



&lt;Element&gt;
 &lt;Position X="402" Y="323"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger r,percent) 1 &amp;gt;&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_cargo_off.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="339" Y="313"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger r,percent) 1 &amp;gt; if{ (L:Door Cargo r,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_cargo_on_r.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="341" Y="360"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger r,percent) 0 &amp;gt;&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_pass_r.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="164" Y="466"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(A:Eng2 Combustion,bool) 0 == (A:Eng3 Combustion,bool) 0 == &amp;amp;&amp;amp; if{ (A:SIM ON GROUND, bool) || if{ (L:EngineCovers,bool) } }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_eng_cover.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="22" Y="535"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger l,percent) 1 &amp;lt; if{ (L:Door Eng l,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_eng_on_l.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="301" Y="535"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:Door passenger r,percent) 0 == if{ (L:Door Eng r,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_eng_on_r.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="269" Y="747"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(A:SIM ON GROUND, bool) || if{ (L:Door baggage,position) }&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_baggage_on.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="199" Y="382"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:SeatAft,bool)&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_pass.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
 &lt;Position X="199" Y="305"/&gt;
   &lt;Select&gt;
      &lt;Value&gt;(L:SeatFwd,bool)&lt;/Value&gt;
        &lt;Case Value="1"&gt;
            &lt;Image Name="cntl_pass.bmp"/&gt;
        &lt;/Case&gt;
    &lt;/Select&gt;
&lt;/Element&gt;

&lt;Element&gt;
  &lt;Select&gt;
	&lt;Value&gt;
	  (L:Door Eng l,position) 0 == if{ 1 (&amp;gt;L:doorcntl,bool) } els{ 0 (&amp;gt;L:doorcntl,bool) }
	  (L:Door Eng r,position) 0 == if{ 1 (&amp;gt;L:doorcntr,bool) } els{ 0 (&amp;gt;L:doorcntr,bool) }
	&lt;/Value&gt;
  &lt;/Select&gt;
&lt;/Element&gt;



 &lt;Mouse&gt;
    &lt;Area Left="199" Top="305" Width="96" Height="42"&gt;
      &lt;Tooltip ID=""&gt;Passenger Seats&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(A:SIM ON GROUND, bool) if{ (L:SeatFwd,bool) ! (&amp;gt;L:SeatFwd,bool) }&lt;/Click&gt;
    &lt;/Area&gt;
	
    &lt;Area Left="199" Top="382" Width="96" Height="42"&gt;
      &lt;Tooltip ID=""&gt;Passenger Seats&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(A:SIM ON GROUND, bool) if{ (L:SeatAft,bool) ! (&amp;gt;L:SeatAft,bool) }&lt;/Click&gt;
    &lt;/Area&gt;
	
     &lt;Area Left="281" Top="0" Width="55" Height="69"&gt;
      &lt;Tooltip ID=""&gt;External Power&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:ExternalPower,bool) ! (&amp;gt;L:ExternalPower,bool)&lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="198" Top="51" Width="96" Height="42"&gt;
      &lt;Tooltip ID=""&gt;Pitot Covers&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(A:SIM ON GROUND, bool) if{ (L:pitotcovers,bool) ! (&amp;gt;L:pitotcovers,bool) }&lt;/Click&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="213" Top="110" Width="66" Height="68"&gt;
      &lt;Tooltip&gt;%Nose Compartment(%((L:NoseDoor,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(A:SIM ON GROUND, bool) if{ (L:NoseDoor,position) ! (&amp;gt;L:NoseDoor,position) }&lt;/Click&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="25" Top="240" Width="69" Height="42"&gt;
      &lt;Tooltip&gt;%Copilot Door(%((L:Copilotdoor,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:Copilotdoor,position) ! (&amp;gt;L:Copilotdoor,position)&lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="25" Top="323" Width="69" Height="42"&gt;
      &lt;Tooltip&gt;%Cargo Door(%((L:Door Cargo l,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:Door passenger l,percent) 1 &amp;gt; if{ (L:Door Cargo l,position) ! (&amp;gt;L:Door Cargo l,position) }&lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="402" Top="323" Width="69" Height="42"&gt;
      &lt;Tooltip&gt;%Cargo Door(%((L:Door Cargo r,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:Door passenger r,percent) 1 &amp;gt; if{ (L:Door Cargo r,position) ! (&amp;gt;L:Door Cargo r,position) }&lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="32" Top="392" Width="50" Height="119"&gt;
      &lt;Tooltip&gt;%Passenger Door(%((L:Door passenger l,percent))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
	  &lt;Click Kind="LeftSingle+LeftDrag+Wheel"&gt;
	       (L:doorcntl,bool) 1 == if{
		     (M:Event) 'LeftSingle' scmp 0 !=
             if{
               (L:Doorpassengerl, position) s0 0 !=
               if{
                  (L:Door passenger l,percent) (M:Y) l0 &amp;lt;
                  if{ 5 - 0 max } els{ l0 (M:Y) &amp;lt; if{  5 + 100 min } }
                  (&amp;gt;L:Door passenger l,percent)
                  }
                }
             (M:Y) (&amp;gt;L:Doorpassengerl, position)
		   }
	  &lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="408" Top="392" Width="50" Height="119"&gt;
      &lt;Tooltip&gt;%Passenger Door(%((L:Door passenger r,percent))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
	  &lt;Click Kind="LeftSingle+LeftDrag+Wheel"&gt;
	       (L:doorcntr,bool) 1 == if{
		     (M:Event) 'LeftSingle' scmp 0 !=
             if{
               (L:Doorpassengerr, position) s0 0 !=
               if{
                  (L:Door passenger r,percent) (M:Y) l0 &amp;lt;
                  if{ 5 - 0 max } els{ l0 (M:Y) &amp;lt; if{  5 + 100 min } }
                  (&amp;gt;L:Door passenger r,percent)
                  }
                }
             (M:Y) (&amp;gt;L:Doorpassengerr, position)
		   }
	  &lt;/Click&gt;
    &lt;/Area&gt;
    
	&lt;Area Left="22" Top="567" Width="68" Height="42"&gt;
      &lt;Tooltip&gt;%Engine Door(%((L:Door Eng l,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:Door passenger l,position) 0 == if{ (L:Door Eng l,position) ! (&amp;gt;L:Door Eng l,position) }&lt;/Click&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="399" Top="567" Width="68" Height="42"&gt;
      &lt;Tooltip&gt;%Engine Door(%((L:Door Eng r,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:Door passenger r,position) 0 == if{ (L:Door Eng r,position) ! (&amp;gt;L:Door Eng r,position) }&lt;/Click&gt;
    &lt;/Area&gt;

    &lt;Area Left="212" Top="617" Width="68" Height="42"&gt;
      &lt;Tooltip ID=""&gt;Engine Covers&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:EngineCovers,bool) ! (&amp;gt;L:EngineCovers,bool)&lt;/Click&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="313" Top="764" Width="82" Height="42"&gt;
      &lt;Tooltip&gt;%Baggage Door(%((L:Door baggage,position))%{if}Open%{else}Closed%{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(A:SIM ON GROUND, bool) if{ (L:Door baggage,position) ! (&amp;gt;L:Door baggage,position) }&lt;/Click&gt;
    &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Radioalt.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Radioalt" Version="1.0"&gt;
 &lt;Image Name="radioalt_background.bmp"/&gt;
 
  &lt;Element&gt;
  &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="radioaltdecis_needle.bmp"&gt;
      &lt;Axis X="10" Y="101"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="-10" Maximum="1500"&gt;(A:DECISION HEIGHT,FEET)&lt;/Value&gt;
         &lt;Nonlinearity&gt;
          &lt;Item Value="0" Degrees="0"/&gt;
          &lt;Item Value="50" Degrees="45"/&gt;
          &lt;Item Value="100" Degrees="85.7"/&gt;
          &lt;Item Value="150" Degrees="132.4"/&gt;
          &lt;Item Value="200" Degrees="180"/&gt;
		  &lt;Item Value="300" Degrees="-171"/&gt;
          &lt;Item Value="500" Degrees="-152.8"/&gt;
          &lt;Item Value="1000" Degrees="-109.2"/&gt;
          &lt;Item Value="1500" Degrees="-66"/&gt;
       &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
  &lt;Position X="0" Y="0"/&gt;
   &lt;MaskImage Name="radioalt_win.bmp"&gt;
      &lt;Axis X="125" Y="125"/&gt;
   &lt;/MaskImage&gt;
      &lt;Image Name="radioalt_Needle.bmp"&gt;
      &lt;Axis X="16" Y="94"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="-10" Maximum="1600"&gt;(L:MasterDcBus,bool) if{ (A:RADIO HEIGHT,FEET) (L:Radiotest,Feet) + (L:OVERRADIOH,FEET) + }&lt;/Value&gt;
       &lt;Nonlinearity&gt;
          &lt;Item Value="0" Degrees="0"/&gt;
          &lt;Item Value="50" Degrees="45"/&gt;
          &lt;Item Value="100" Degrees="85.7"/&gt;
          &lt;Item Value="150" Degrees="132.4"/&gt;
          &lt;Item Value="200" Degrees="180"/&gt;
		  &lt;Item Value="300" Degrees="-171"/&gt;
          &lt;Item Value="500" Degrees="-152.8"/&gt;
          &lt;Item Value="1000" Degrees="-109.2"/&gt;
          &lt;Item Value="1500" Degrees="-66"/&gt;
		  &lt;Item Value="1600" Degrees="-33"/&gt;
	&lt;/Nonlinearity&gt;
	&lt;Delay DegreesPerSecond="150"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
     &lt;Select&gt;
        &lt;Value&gt;
		(L:MStater,bool) 1 == if{ 1600 (&amp;gt;L:OVERRADIOH,FEET) } els{ 0 (&amp;gt;L:OVERRADIOH,FEET) }
		&lt;/Value&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
     &lt;Select&gt;
        &lt;Value&gt;
		 (L:MStater,bool) 1 == if{ 1 (&amp;gt;L:WARNINGOFF,BOOL) } els{ 0 (&amp;gt;L:WARNINGOFF,BOOL) }
		&lt;/Value&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
     &lt;Select&gt;
        &lt;Value&gt;
		(L:Testradaralt,bool) if{ 100 (&amp;gt;L:Radiotest,Feet) } els{ 0 (&amp;gt;L:Radiotest,Feet) }
		&lt;/Value&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;
 
  &lt;Element&gt;
     &lt;Select&gt;
        &lt;Value&gt;
		 (L:MStater,bool) || (L:Testradaralt,bool) || if{ 0 (&amp;gt;L:Raltflag,bool) } els{  1 (&amp;gt;L:Raltflag,bool) }
		&lt;/Value&gt;
     &lt;/Select&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
     &lt;MaskImage Name="radioalt_win.bmp"&gt;
      &lt;Axis X="193" Y="46"/&gt;
     &lt;/MaskImage&gt;
     &lt;Image Name="radioalt_flag_off.bmp" PointsTo="Weast"&gt;
      &lt;Axis X="76" Y="15"/&gt;
     &lt;/Image&gt;
     &lt;Rotate&gt;
        &lt;Value&gt;(L:MasterDcBus,bool) (L:Raltflag,bool) * &lt;/Value&gt;
         &lt;Nonlinearity&gt;
	      &lt;Item Value="0" Degrees="0"/&gt;
	      &lt;Item Value="1" Degrees="150"/&gt;
    	&lt;/Nonlinearity&gt;
       &lt;Delay DegreesPerSecond="200"/&gt;
     &lt;/Rotate&gt;
   &lt;/Element&gt;

  &lt;Element&gt;
     &lt;Position X="23" Y="22"/&gt;
     &lt;Visible&gt;(L:MasterDcBus,bool) (L:WARNINGOFF,BOOL) 0 == &amp;amp;&amp;amp; if{ (A:WARNING LOW HEIGHT,BOOL) || (L:Testradaralt,bool) || }&lt;/Visible&gt;
         &lt;Image Name="radioalt_dh_on.bmp" Bright="Yes"/&gt;
  &lt;/Element&gt;
  
 
  &lt;Mouse&gt;
    &lt;Tooltip ID="TOOLTIPTEXT_RADIO_ALTIMETER_FEET"/&gt;
		 
    &lt;Area Left="196" Top="200" Width="40" Height="40"&gt;
	   &lt;Tooltip ID="TOOLTIPTEXT_RADIO_ALTIMETER_DH_FEET"/&gt;
      &lt;Area Right="20"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="DECREASE_DECISION_HEIGHT" Repeat="Yes"/&gt;
      &lt;/Area&gt;
      &lt;Area Left="20"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="INCREASE_DECISION_HEIGHT" Repeat="Yes"/&gt;
      &lt;/Area&gt;
    &lt;/Area&gt;

    &lt;Area Left="26" Top="214" Width="10" Height="10"&gt;
        &lt;Tooltip ID=""&gt;DH Test&lt;/Tooltip&gt;
	    &lt;Cursor Type="Hand"/&gt;
	    &lt;Click Kind="LeftSingle+Leave"&gt;
		(M:Event) 'LeftSingle' scmp 0 == (L:Testradaralt,bool) 0 == and if{ 1 (&amp;gt;L:Testradaralt,bool) }
  		(M:Event) 'Leave' scmp 0 == (L:Testradaralt,bool) 1 == and if{ 0 (&amp;gt;L:Testradaralt,bool) }			
	    &lt;/Click&gt;
       &lt;/Area&gt;
   &lt;/Mouse&gt;
  
&lt;/Gauge&gt;

</pre><br/><hr/><br/><h1>RPMN1E1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="RPMN1E1" Version="1.0"&gt;
 &lt;Image Name="rpmN1_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="RPM_needle1.bmp" PointsTo="North"&gt;
      &lt;Axis X="17" Y="60"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:RPM N1 E1,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="86" Y="20"/&gt;
          &lt;Item Value="10" X="118" Y="26"/&gt;
          &lt;Item Value="20" X="144" Y="45"/&gt;
		  &lt;Item Value="30" X="158" Y="74"/&gt;		  
          &lt;Item Value="40" X="157" Y="107"/&gt;
          &lt;Item Value="50" X="142" Y="135"/&gt;
          &lt;Item Value="60" X="115" Y="153"/&gt;
          &lt;Item Value="70" X="84" Y="158"/&gt;
          &lt;Item Value="80" X="52" Y="148"/&gt;
          &lt;Item Value="90" X="30" Y="125"/&gt;
 	      &lt;Item Value="100" X="20" Y="94"/&gt;
		  &lt;Item Value="110" X="26" Y="60"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
 
  &lt;Element&gt;
    &lt;Position X="67" Y="52"/&gt;
    &lt;Image Name="RPM_needle2.bmp" PointsTo="North"&gt;
      &lt;Axis X="11" Y="11"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="110"&gt;(L:RPM N1 E1,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="66" Y="39"/&gt;
          &lt;Item Value="5" X="67" Y="63"/&gt;
      &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="280"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 1 Gas Generator RPM (%((L:RPM N1 E1,percent))%!d!%%)%&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>RPMN1E2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="RPMN2E1" Version="1.0"&gt;
 &lt;Image Name="rpmN1_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="90" Y="90"/&gt;
    &lt;Image Name="RPM_needle1.bmp" PointsTo="North"&gt;
      &lt;Axis X="17" Y="60"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="110"&gt;(L:RPM N1 E2,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="86" Y="20"/&gt;
          &lt;Item Value="10" X="118" Y="26"/&gt;
          &lt;Item Value="20" X="144" Y="45"/&gt;
		  &lt;Item Value="30" X="158" Y="74"/&gt;		  
          &lt;Item Value="40" X="157" Y="107"/&gt;
          &lt;Item Value="50" X="142" Y="135"/&gt;
          &lt;Item Value="60" X="115" Y="153"/&gt;
          &lt;Item Value="70" X="84" Y="158"/&gt;
          &lt;Item Value="80" X="52" Y="148"/&gt;
          &lt;Item Value="90" X="30" Y="125"/&gt;
 	      &lt;Item Value="100" X="20" Y="94"/&gt;
		  &lt;Item Value="110" X="26" Y="60"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="67" Y="52"/&gt;
    &lt;Image Name="RPM_needle2.bmp" PointsTo="North"&gt;
      &lt;Axis X="11" Y="11"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:RPM N1 E2,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="66" Y="39"/&gt;
          &lt;Item Value="5" X="67" Y="63"/&gt;
      &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="280"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
     &lt;Tooltip&gt;%Engine 2 Gas Generator RPM (%((L:RPM N1 E2,percent))%!d!%%)%&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_ADF.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_ADF" Version="1.0"&gt;
  &lt;Image Name="r_adf.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="212" Y="211"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:adf,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="50" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
        &lt;String&gt;%((A:ADF ACTIVE FREQUENCY:1, kHz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="50" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:ADF ACTIVE FREQUENCY:2, kHz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%NAV 2 On/Off(%((L:adf,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:adf,bool) ! (&amp;gt;L:adf,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="211" Top="139" Width="22" Height="34"&gt;
       &lt;Click Event="ADF2_100_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="211" Top="173" Width="22" Height="34"&gt;
       &lt;Click Event="ADF2_100_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="233" Top="139" Width="24" Height="34"&gt;
       &lt;Click Event="ADF2_10_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="233" Top="173" Width="24" Height="34"&gt;
       &lt;Click Event="ADF2_10_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="257" Top="139" Width="22" Height="34"&gt;
       &lt;Click Event="ADF2_1_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="257" Top="173" Width="22" Height="34"&gt;
       &lt;Click Event="ADF2_1_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;
	
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
       &lt;Cursor Type="Hand"/&gt;
	    &lt;Click&gt;
		   (A:ADF ACTIVE FREQUENCY:2,Frequency ADF BCD32) (&amp;gt;L:ADF Standby,Frequency ADF BCD32)
		   (A:ADF1 ACTIVE FREQUENCY,Frequency ADF BCD32) (&amp;gt;L:ADF Active,Frequency ADF BCD32)
		   (L:ADF Active,Frequency ADF BCD32) (&amp;gt;K:ADF2_COMPLETE_SET) 
		   (L:ADF Standby,Frequency ADF BCD32) (&amp;gt;K:ADF_COMPLETE_SET) 
       &lt;/Click&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_ADF_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_ADF" Version="1.0"&gt;
  &lt;Image Name="r_adf_2d.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="65" Y="190"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:adf,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:adf,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="50" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
        &lt;String&gt;%((A:ADF ACTIVE FREQUENCY:1, kHz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="50" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:ADF ACTIVE FREQUENCY:2, kHz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%NAV 2 On/Off(%((L:adf,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:adf,bool) ! (&amp;gt;L:adf,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="109" Top="134" Width="22" Height="33"&gt;
       &lt;Click Event="ADF2_100_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="109" Top="167" Width="22" Height="33"&gt;
       &lt;Click Event="ADF2_100_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="131" Top="134" Width="24" Height="33"&gt;
       &lt;Click Event="ADF2_10_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="131" Top="167" Width="24" Height="33"&gt;
       &lt;Click Event="ADF2_10_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="153" Top="134" Width="22" Height="33"&gt;
       &lt;Click Event="ADF2_1_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="153" Top="167" Width="22" Height="33"&gt;
       &lt;Click Event="ADF2_1_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;
	
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
       &lt;Cursor Type="Hand"/&gt;
	    &lt;Click&gt;
		   (A:ADF ACTIVE FREQUENCY:2,Frequency ADF BCD32) (&amp;gt;L:ADF Standby,Frequency ADF BCD32)
		   (A:ADF1 ACTIVE FREQUENCY,Frequency ADF BCD32) (&amp;gt;L:ADF Active,Frequency ADF BCD32)
		   (L:ADF Active,Frequency ADF BCD32) (&amp;gt;K:ADF2_COMPLETE_SET) 
		   (L:ADF Standby,Frequency ADF BCD32) (&amp;gt;K:ADF_COMPLETE_SET) 
       &lt;/Click&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_COMM1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_COMM1" Version="1.0"&gt;
  &lt;Image Name="r_comm.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="212" Y="211"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:comm1,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM1 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM1 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%Com 1 On/Off(%((L:comm1,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:comm1,bool) ! (&amp;gt;L:comm1,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="211" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_COM1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="245" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_COM1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="219" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_COM1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="245" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_COM1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:COM_RADIO) 0 (&gt;K:SELECT_1) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_COMM1_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_COMM1" Version="1.0"&gt;
  &lt;Image Name="r_comm_2d.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="65" Y="190"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:comm1,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM1 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM1 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%Com 1 On/Off(%((L:comm1,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:comm1,bool) ! (&amp;gt;L:comm1,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="108" Top="134" Width="33" Height="33"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="108" Top="167" Width="33" Height="33"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="141" Top="134" Width="33" Height="33"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="141" Top="167" Width="33" Height="33"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:comm1,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:COM_RADIO) 0 (&gt;K:SELECT_1) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_COMM2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_COMM2" Version="1.0"&gt;
  &lt;Image Name="r_comm.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="212" Y="211"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:comm2,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM2 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM2 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%Com 2 On/Off(%((L:comm2,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:comm2,bool) ! (&amp;gt;L:comm2,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="211" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_WHOLE_INCREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="245" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_WHOLE_DECREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="219" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_FRACT_INCREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="245" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_FRACT_DECREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:COM_RADIO) 0 (&gt;K:SELECT_2) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_COMM2_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_COMM1" Version="1.0"&gt;
  &lt;Image Name="r_comm_2d.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="65" Y="190"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:comm2,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM2 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:COM2 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%Com 2 On/Off(%((L:comm2,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:comm2,bool) ! (&amp;gt;L:comm2,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="108" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_WHOLE_INCREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="108" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_WHOLE_DECREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="141" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_FRACT_INCREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="141" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_COM2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_COMM2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="COM_STBY_RADIO_FRACT_DECREASE" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:comm2,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:COM_RADIO) 0 (&gt;K:SELECT_2) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_NAV1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_NAV1" Version="1.0"&gt;
  &lt;Image Name="r_nav.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="212" Y="211"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:nav1,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV1 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV1 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%NAV 1 On/Off(%((L:nav1,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:nav1,bool) ! (&amp;gt;L:nav1,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="211" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="245" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="219" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="245" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:NAV_RADIO) 0 (&gt;K:SELECT_1) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_NAV1_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_NAV1" Version="1.0"&gt;
  &lt;Image Name="r_nav_2d.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="65" Y="190"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:nav1,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV1 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV1 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%NAV 1 On/Off(%((L:nav1,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:nav1,bool) ! (&amp;gt;L:nav1,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="108" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="108" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="141" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="141" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV1"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV1_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV1_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:nav1,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:NAV_RADIO) 0 (&gt;K:SELECT_1) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_NAV2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_NAV2" Version="1.0"&gt;
  &lt;Image Name="r_nav.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="212" Y="211"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:nav2,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV2 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV2 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%NAV 2 On/Off(%((L:nav2,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:nav2,bool) ! (&amp;gt;L:nav2,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="211" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="245" Top="139" Width="34" Height="69"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="219" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="245" Top="82" Width="26" Height="52"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:NAV_RADIO) 0 (&gt;K:SELECT_2) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_NAV2_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_NAV2" Version="1.0"&gt;
  &lt;Image Name="r_nav_2d.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="65" Y="190"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_ledon.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:nav2,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="31" Y="34"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV2 ACTIVE FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
   &lt;Element&gt; 
    &lt;Position X="31" Y="73"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
       &lt;String&gt;%((A:NAV2 STANDBY FREQUENCY, MHz))%!6.2f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%NAV 2 On/Off(%((L:nav2,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:nav2,bool) ! (&amp;gt;L:nav2,bool)&lt;/Click&gt;
    &lt;/Area&gt;
    &lt;Area Left="108" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_WHOLE_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;      
    &lt;Area Left="108" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_WHOLE_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="141" Top="134" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_FRACT_INC" Repeat="Yes"/&gt;
    &lt;/Area&gt;   
    &lt;Area Left="141" Top="167" Width="33" Height="33"&gt;
        &lt;Help ID="HELPID_RADIO_NAV2"/&gt;
        &lt;Tooltip ID="TOOLTIPTEXT_NAV2_FREQ"/&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Event="NAV2_RADIO_FRACT_DEC" Repeat="Yes"/&gt;
    &lt;/Area&gt;
    &lt;Area Left="168" Top="91" Width="17" Height="29"&gt;
       &lt;Tooltip ID=""&gt;Transfer Button&lt;/Tooltip&gt;  
	   &lt;Click&gt;(L:MasterACDC, bool) (L:nav2,bool) 1 == &amp;amp;&amp;amp; if{ 0 (&gt;K:NAV_RADIO) 0 (&gt;K:SELECT_2) 0 (&gt;K:FREQUENCY_SWAP) }&lt;/Click&gt;
       &lt;Cursor Type="Hand"/&gt;
    &lt;/Area&gt;  
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_XPDR.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_XPDR" Version="1.0"&gt;
  &lt;Image Name="r_xpdr.bmp"/&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:xpdr,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on2.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="235" Y="7"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:xpdr,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:xpdr,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="50" Y="50"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
        &lt;String&gt;%((A:TRANSPONDER1 CODE, Hz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="235" Top="7" Width="40" Height="40"&gt;
      &lt;Tooltip&gt;%XPDR  On/Off(%((L:xpdr,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:xpdr,bool) ! (&amp;gt;L:xpdr,bool)&lt;/Click&gt;
    &lt;/Area&gt;
	
    &lt;Area Left="211" Top="139" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1000_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="211" Top="173" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1000_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="228" Top="139" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_100_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="228" Top="173" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_100_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="245" Top="139" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_10_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="245" Top="173" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_10_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="262" Top="139" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="262" Top="173" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>R_XPDR_2d.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
 &lt;Gauge Name="R_XPDR" Version="1.0"&gt;
  &lt;Image Name="r_xpdr_d2.bmp"/&gt;

  &lt;Element&gt;
   &lt;Position X="19" Y="28"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:MasterACDC, bool) (L:xpdr,bool) 1 == &amp;amp;&amp;amp;&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_screen_on2.bmp" Bright="Yes"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Position X="30" Y="155"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:xpdr,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="r_knob.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
   &lt;Visible&gt;(L:MasterACDC, bool) (L:xpdr,bool) 1 == &amp;amp;&amp;amp;&lt;/Visible&gt; 
   &lt;Element&gt; 
    &lt;Position X="50" Y="50"/&gt;
     &lt;Text X="112" Y="34" Length="7" Font="Quartz" Fixed="Yes" Adjust="Center" VerticalAdjust="Center" Color="RED" Bright="Yes"&gt;
        &lt;String&gt;%((A:TRANSPONDER1 CODE, Hz))%!4.0f!&lt;/String&gt;
     &lt;/Text&gt;
   &lt;/Element&gt;
  &lt;/Element&gt;
 
 &lt;Mouse&gt;
    &lt;Area Left="30" Top="155" Width="38" Height="38"&gt;
      &lt;Tooltip&gt;%XPDR  On/Off(%((L:xpdr,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:xpdr,bool) ! (&amp;gt;L:xpdr,bool)&lt;/Click&gt;
    &lt;/Area&gt;
	
    &lt;Area Left="109" Top="134" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1000_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="109" Top="167" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1000_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="125" Top="134" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_100_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="125" Top="167" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_100_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

    &lt;Area Left="141" Top="134" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_10_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="141" Top="167" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_10_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;
	
	&lt;Area Left="157" Top="134" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1_INC" Repeat="Yes"/&gt;
       &lt;Cursor Type="UpArrow"/&gt;
    &lt;/Area&gt;      

    &lt;Area Left="157" Top="167" Width="17" Height="34"&gt;
       &lt;Click Event="XPNDR_1_DEC" Repeat="Yes"/&gt;
       &lt;Cursor Type="DownArrow"/&gt;
    &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>STBATT.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="STBATT" Version="1.0"&gt;
 &lt;Image Name="stbatt_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="0" Y="0"/&gt;
    &lt;MaskImage Name="stbatt_win.bmp"&gt;
       &lt;Axis X="130" Y="134"/&gt;
    &lt;/MaskImage&gt;
      &lt;Image Name="stbatt_horizon.bmp"&gt;
         &lt;Axis X="125" Y="125"/&gt;
      &lt;/Image&gt;
      &lt;Shift&gt;
         &lt;Value Minimum="-40" Maximum="40"&gt;(L:Masterstbatt,bool) if{ (A:Attitude indicator pitch degrees,degrees) /-/ } els{ 20 }&lt;/Value&gt;
         &lt;Scale Y="2.2"/&gt;
      &lt;Delay PixelsPerSecond="90"/&gt;
      &lt;/Shift&gt;
      &lt;Rotate&gt;
         &lt;Value&gt;(L:Masterstbatt,bool) if{ (A:Attitude indicator bank degrees,radians) } els{ 0.50 }&lt;/Value&gt;
      &lt;Delay DegreesPerSecond="60"/&gt;
      &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="84" Y="97"/&gt;
    &lt;MaskImage Name="stbatt_win_pitch_point.bmp"&gt;
       &lt;Axis X="46" Y="36"/&gt;
    &lt;/MaskImage&gt;
      &lt;Image Name="stbatt_pitch_point.bmp"&gt;
         &lt;Axis X="46" Y="3"/&gt;
      &lt;/Image&gt;
      &lt;Shift&gt;
         &lt;Value Minimum="-12" Maximum="12"&gt;(G:Var1)&lt;/Value&gt;
         &lt;Scale Y="1"/&gt;
      &lt;/Shift&gt;
  &lt;/Element&gt;
    
  &lt;Element&gt;
    &lt;Position X="130" Y="134"/&gt;
    &lt;Image Name="stbatt_pointer.bmp" PointsTo="East"&gt;
      &lt;Axis X="20" Y="69"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:Masterstbatt,bool) if{ (A:Attitude indicator bank degrees,radians) } els{ 0.51 }&lt;/Value&gt;
	&lt;Delay DegreesPerSecond="60"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="122" Y="0"/&gt;
    &lt;MaskImage Name="stbatt_flag_win.bmp"&gt;
       &lt;Axis X="90" Y="59"/&gt;
    &lt;/MaskImage&gt;
      &lt;Image Name="stbatt_flag.bmp"&gt;
         &lt;Axis X="29" Y="4"/&gt;
      &lt;/Image&gt;
       &lt;Rotate&gt;
        &lt;Value&gt;(L:Masterstbatt,bool)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
		  &lt;Item Value="0" Degrees="0"/&gt;
	      &lt;Item Value="1" Degrees="113"/&gt;
	    &lt;/Nonlinearity&gt;
        &lt;Delay DegreesPerSecond="170"/&gt;
      &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  
  &lt;Mouse&gt;
  &lt;Tooltip&gt;Attitude Indicator (Bank %((L:Masterstbatt,bool) if{ (A:ATTITUDE INDICATOR BANK DEGREES, degrees) })%!d!&amp;#176;, Pitch %((L:Masterstbatt,bool) if{ (A:Attitude indicator pitch degrees,degrees) /-/ })%!d!&amp;#176;)&lt;/Tooltip&gt;
    &lt;Area Left="111" Top="193" Width="36" Height="36"&gt;
      &lt;Area Right="18"&gt;
        &lt;Cursor Type="DownArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
          (G:Var1) 1 + 12 min (&amp;gt;G:Var1)
        &lt;/Click&gt;
      &lt;/Area&gt;
      &lt;Area Left="18"&gt;
        &lt;Cursor Type="UpArrow"/&gt;
        &lt;Click Repeat="Yes"&gt;
          (G:Var1) 1 - -12 max (&amp;gt;G:Var1)
        &lt;/Click&gt;
      &lt;/Area&gt;
   &lt;/Area&gt;
   
   &lt;Area Left="199" Top="197" Width="46" Height="46"&gt;
     &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:stbatt,bool) ! (&amp;gt;L:stbatt,bool)&lt;/Click&gt;
   &lt;/Area&gt;
	 
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Tachometer.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Tachometer" Version="1.0"&gt;
 &lt;Image Name="tachom_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="tachoeng1_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="7" Y="31"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="100"&gt;(L:Eng1N2,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="119" Y="26"/&gt;
          &lt;Item Value="10" X="165" Y="35"/&gt;
          &lt;Item Value="20" X="202" Y="64"/&gt;
		  &lt;Item Value="30" X="220" Y="106"/&gt;		  
          &lt;Item Value="40" X="219" Y="151"/&gt;
          &lt;Item Value="50" X="198" Y="191"/&gt;
          &lt;Item Value="60" X="158" Y="217"/&gt;
          &lt;Item Value="70" X="113" Y="222"/&gt;
          &lt;Item Value="80" X="67" Y="205"/&gt;
          &lt;Item Value="90" X="36" Y="168"/&gt;
 	      &lt;Item Value="100" X="27" Y="99"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="16"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="tachoeng2_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="7" Y="31"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="100"&gt;(L:Eng2N2,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="119" Y="26"/&gt;
          &lt;Item Value="10" X="165" Y="35"/&gt;
          &lt;Item Value="20" X="202" Y="64"/&gt;
		  &lt;Item Value="30" X="220" Y="106"/&gt;		  
          &lt;Item Value="40" X="219" Y="151"/&gt;
          &lt;Item Value="50" X="198" Y="191"/&gt;
          &lt;Item Value="60" X="158" Y="217"/&gt;
          &lt;Item Value="70" X="113" Y="222"/&gt;
          &lt;Item Value="80" X="67" Y="205"/&gt;
          &lt;Item Value="90" X="36" Y="168"/&gt;
 	      &lt;Item Value="100" X="27" Y="99"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="16"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="tachorotor_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="7" Y="31"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="100"&gt;(A:Eng Rotor Rpm,percent)&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="119" Y="26"/&gt;
          &lt;Item Value="10" X="165" Y="35"/&gt;
          &lt;Item Value="20" X="202" Y="64"/&gt;
		  &lt;Item Value="30" X="220" Y="106"/&gt;		  
          &lt;Item Value="40" X="219" Y="151"/&gt;
          &lt;Item Value="50" X="198" Y="191"/&gt;
          &lt;Item Value="60" X="158" Y="217"/&gt;
          &lt;Item Value="70" X="113" Y="222"/&gt;
          &lt;Item Value="80" X="67" Y="205"/&gt;
          &lt;Item Value="90" X="36" Y="168"/&gt;
 	      &lt;Item Value="100" X="27" Y="99"/&gt;
         &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Mouse&gt;
     &lt;Tooltip&gt;Tachometer&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>TCAS.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="TCAS" Version="1.0"&gt;
 &lt;Image Name="tcas_background.bmp"/&gt;

   &lt;Element&gt;
      &lt;Select&gt;
         &lt;Value&gt;(L:MasterDcBus,bool) if{ (L:tcas,bool) }&lt;/Value&gt;
         &lt;Case Value="1"&gt;
            &lt;Image Name="tcas_on.bmp" Bright="Yes"/&gt;
         &lt;/Case&gt;
      &lt;/Select&gt;
   &lt;/Element&gt;
   
  &lt;Element&gt;
    &lt;Position X="9" Y="204"/&gt;
    &lt;Select&gt;
      &lt;Value&gt;(L:tcas,bool)&lt;/Value&gt;
      &lt;Case Value="1"&gt;
         &lt;Image Name="tcas_on_1.bmp"/&gt;
      &lt;/Case&gt;
    &lt;/Select&gt;
  &lt;/Element&gt;
  
  &lt;Mouse&gt;
    &lt;Area Left="9" Top="204" Width="18" Height="18"&gt;
      &lt;Tooltip&gt;%TCAS On/Off(%((L:tcas,bool))%{if}On%{else}Off %{end})&lt;/Tooltip&gt;
      &lt;Cursor Type="Hand"/&gt;
      &lt;Click&gt;(L:tcas,bool) ! (&amp;gt;L:tcas,bool)&lt;/Click&gt;
    &lt;/Area&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Torque.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Torque" Version="1.0"&gt;
 &lt;Image Name="torque_background.bmp"/&gt;

  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="trotor_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="6" Y="6"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="110"&gt;(L:MasterACDC,bool) (L:Combustionm,bool) &amp;amp;&amp;amp; if{ (L:Trotor,percent) } els{ 0 }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="0" X="125" Y="193"/&gt;
          &lt;Item Value="10" X="101" Y="190"/&gt;
		  &lt;Item Value="20" X="85" Y="182"/&gt;
          &lt;Item Value="30" X="71" Y="171"/&gt;		  
          &lt;Item Value="40" X="62" Y="158"/&gt;
          &lt;Item Value="50" X="56" Y="141"/&gt;
          &lt;Item Value="60" X="54" Y="123"/&gt;
          &lt;Item Value="70" X="56" Y="106"/&gt;
          &lt;Item Value="80" X="63" Y="88"/&gt;
          &lt;Item Value="90" X="74" Y="74"/&gt;
 	      &lt;Item Value="100" X="89" Y="60"/&gt;
		  &lt;Item Value="110" X="106" Y="54"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="12"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="teng1_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="8" Y="8"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="0" Maximum="100"&gt;(L:MasterACDC,bool) (A:Eng2 Combustion,bool) &amp;amp;&amp;amp; if{ (L:Eng1TQ,percent) } els{ 0 }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
 	      &lt;Item Value="100" X="143" Y="56"/&gt;  
          &lt;Item Value="90" X="162" Y="64"/&gt;		  
          &lt;Item Value="80" X="178" Y="74"/&gt;		  
          &lt;Item Value="70" X="186" Y="90"/&gt;		  
          &lt;Item Value="60" X="197" Y="108"/&gt;		  
          &lt;Item Value="50" X="195" Y="128"/&gt;
          &lt;Item Value="40" X="191" Y="146"/&gt;
          &lt;Item Value="30" X="184" Y="161"/&gt;
		  &lt;Item Value="20" X="171" Y="176"/&gt; 
		  &lt;Item Value="10" X="155" Y="187"/&gt;
		  &lt;Item Value="3" X="137" Y="193"/&gt;
		  &lt;Item Value="0" X="125" Y="193"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="12"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="teng2_needle.bmp" PointsTo="South"&gt;
      &lt;Axis X="8" Y="8"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value Minimum="-5" Maximum="100"&gt;(L:MasterACDC,bool) (A:Eng3 Combustion,bool) &amp;amp;&amp;amp; if{ (L:Eng2TQ,percent) } els{ 0 }&lt;/Value&gt;
      &lt;Nonlinearity&gt;
 	      &lt;Item Value="100" X="143" Y="56"/&gt;  
          &lt;Item Value="90" X="162" Y="64"/&gt;		  
          &lt;Item Value="80" X="178" Y="74"/&gt;		  
          &lt;Item Value="70" X="186" Y="90"/&gt;		  
          &lt;Item Value="60" X="197" Y="108"/&gt;		  
          &lt;Item Value="50" X="195" Y="128"/&gt;
          &lt;Item Value="40" X="191" Y="146"/&gt;
          &lt;Item Value="30" X="184" Y="161"/&gt;
		  &lt;Item Value="20" X="171" Y="176"/&gt; 
		  &lt;Item Value="10" X="155" Y="187"/&gt;
		  &lt;Item Value="3" X="137" Y="193"/&gt;
		  &lt;Item Value="0" X="125" Y="193"/&gt;
         &lt;/Nonlinearity&gt;
		 &lt;Delay DegreesPerSecond="12"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

   &lt;Mouse&gt;
     &lt;Tooltip&gt;Triple Torque&lt;/Tooltip&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>VOLT1.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="VOLT1" Version="1.0"&gt;
 &lt;Image Name="volts_background.bmp"/&gt;


  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="130"&gt;(L:VoltAC1,volt)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
	 	  &lt;Item Value="0" X="57" Y="142"/&gt;	 
 	      &lt;Item Value="90" X="52" Y="139"/&gt;
		  &lt;Item Value="100" X="28" Y="119"/&gt;
		  &lt;Item Value="110" X="19" Y="90"/&gt;
		  &lt;Item Value="120" X="30" Y="57"/&gt;
		  &lt;Item Value="130" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:VoltDC1,volt)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="30" X="123" Y="39"/&gt;
          &lt;Item Value="25" X="153" Y="68"/&gt;
 	      &lt;Item Value="20" X="153" Y="111"/&gt;
		  &lt;Item Value="15" X="120" Y="140"/&gt;
  		  &lt;Item Value="0" X="112" Y="141"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="amps_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- Volt AC --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Voltage AC Bus 1 (%((L:VoltAC1,volt))%!d!Volts)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- Volt DC --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Voltage DC Bus 1 (%((L:VoltDC1,volt))%!d!Volts)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>VOLT2.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="VOLT2" Version="1.0"&gt;
 &lt;Image Name="volts_background.bmp"/&gt;


  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="0" Maximum="130"&gt;(L:VoltAC2,volt)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
	 	  &lt;Item Value="0" X="57" Y="142"/&gt;	 
 	      &lt;Item Value="90" X="52" Y="139"/&gt;
		  &lt;Item Value="100" X="28" Y="119"/&gt;
		  &lt;Item Value="110" X="19" Y="90"/&gt;
		  &lt;Item Value="120" X="30" Y="57"/&gt;
		  &lt;Item Value="130" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:VoltDC2,volt)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="30" X="123" Y="39"/&gt;
          &lt;Item Value="25" X="153" Y="68"/&gt;
 	      &lt;Item Value="20" X="153" Y="111"/&gt;
		  &lt;Item Value="15" X="120" Y="140"/&gt;
  		  &lt;Item Value="0" X="112" Y="141"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="25"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="amps_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- Volt AC --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Voltage AC Bus 2 (%((L:VoltAC2,volt))%!d!Volts)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- Volt DC --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Voltage DC Bus 2 (%((L:VoltDC2,volt))%!d!Volts)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>Vsi.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="Vsi" Version="1.0"&gt;
 &lt;Image Name="Vsi_background.bmp"/&gt;
 
  &lt;Element&gt;
    &lt;Position X="125" Y="125"/&gt;
    &lt;Image Name="vsi_needle.bmp" PointsTo="West"&gt;
      &lt;Axis X="93" Y="6"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt;
      &lt;Value&gt;(L:pitotcovers,bool) 0 == if{ (A:Vertical speed,feet per minute) }&lt;/Value&gt;
       &lt;Failures&gt;
        &lt;SYSTEM_PITOT_STATIC Action="Freeze"/&gt;
      &lt;/Failures&gt;
      &lt;Nonlinearity&gt;
	      &lt;Item Value="-4000" X="221" Y="140"/&gt;
          &lt;Item Value="-3000" X="201" Y="184"/&gt;
          &lt;Item Value="-2000" X="158" Y="215"/&gt;
          &lt;Item Value="-1000" X="84" Y="213"/&gt;
          &lt;Item Value="-500" X="45" Y="182"/&gt;
          &lt;Item Value="0" X="25" Y="122"/&gt;
          &lt;Item Value="500" X="45" Y="64"/&gt;
          &lt;Item Value="1000" X="84" Y="33"/&gt;
          &lt;Item Value="2000" X="158" Y="31"/&gt;
          &lt;Item Value="3000" X="201" Y="62"/&gt;
 	      &lt;Item Value="4000" X="221" Y="106"/&gt;
         &lt;/Nonlinearity&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
   &lt;Mouse&gt;
     &lt;Help ID="HELPID_GAUGE_VSI"/&gt;
      &lt;Tooltip ID="TOOLTIPTEXT_VSI_FEET_PER_MIN" MetricID="TOOLTIPTEXT_VSI_METERS_PER_SEC"/&gt;
  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/><h1>XMSN.xml</h1><pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Gauge Name="XMSN" Version="1.0"&gt;
 &lt;Image Name="xmsn_background.bmp"/&gt;


&lt;!-- ========================= OIL TEMP ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="72" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp" PointsTo="East"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value Minimum="-5" Maximum="150"&gt;(L:MasterDcBus,bool) 1 ==  if{ (L:XMSNT,celsius) } els{ -5 }&lt;/Value&gt;
        &lt;Nonlinearity&gt;
 	      &lt;Item Value="-5" X="52" Y="139"/&gt;
		  &lt;Item Value="0" X="28" Y="119"/&gt;
		  &lt;Item Value="50" X="19" Y="90"/&gt;
		  &lt;Item Value="100" X="30" Y="57"/&gt;
		  &lt;Item Value="150" X="56" Y="38"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="15"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;

&lt;!-- ========================= OIL PRESS ========================= --&gt; 
  &lt;Element&gt;
    &lt;Position X="106" Y="89"/&gt;
    &lt;Image Name="oil_needle.bmp"&gt;
      &lt;Axis X="0" Y="4"/&gt;
    &lt;/Image&gt;
    &lt;Rotate&gt; 
      &lt;Value&gt;(L:XMSN,psi)&lt;/Value&gt;
        &lt;Nonlinearity&gt;
          &lt;Item Value="100" Degrees="-72"/&gt;		
          &lt;Item Value="80" Degrees="-44"/&gt;		
          &lt;Item Value="60" Degrees="-14"/&gt;
          &lt;Item Value="40" Degrees="15"/&gt;
          &lt;Item Value="20" Degrees="47"/&gt;		  		  		
		  &lt;Item Value="0" Degrees="74"/&gt;
         &lt;/Nonlinearity&gt;
	    &lt;Delay DegreesPerSecond="10"/&gt;
    &lt;/Rotate&gt;
  &lt;/Element&gt;
  
 
  &lt;Element&gt;
   &lt;Position X="63" Y="81"/&gt;
     &lt;Image Name="oil_f.bmp"/&gt;
  &lt;/Element&gt; 
 
  &lt;Mouse&gt;
  
&lt;!-- OIL TEMP --&gt;
   &lt;Area Left="10" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Transmission Oil Temperature(%((L:MasterDcBus,bool) 1 ==  if{ (L:XMSNT,celsius) } els{ -5 })%!d!&amp;#176;C)&lt;/Tooltip&gt;
   &lt;/Area&gt;
   
&lt;!-- OIL PRESS --&gt;
   &lt;Area Left="89" Top="9" Width="80" Height="160"&gt;
      &lt;Tooltip&gt;%Transmission Oil Pressure(%((L:XMSN,psi))%!d!PSI)&lt;/Tooltip&gt;
   &lt;/Area&gt;

  &lt;/Mouse&gt;
&lt;/Gauge&gt;
</pre><br/><hr/><br/></body></html>
