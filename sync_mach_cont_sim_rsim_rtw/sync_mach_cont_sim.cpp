/*
 * sync_mach_cont_sim.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "sync_mach_cont_sim".
 *
 * Model version              : 1.25
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C++ source code generated on : Thu Nov 09 11:21:49 2017
 *
 * Target selection: rsim.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include <math.h>
#include "sync_mach_cont_sim.h"
#include "sync_mach_cont_sim_private.h"
#include "sync_mach_cont_sim_dt.h"

/* user code (top of parameter file) */
extern "C" {
  const int_T gblNumToFiles = 0;
  const int_T gblNumFrFiles = 0;
  const int_T gblNumFrWksBlocks = 0;
  const char *gblSlvrJacPatternFileName =
    "sync_mach_cont_sim_rsim_rtw\\sync_mach_cont_sim_Jpattern.mat";

  /* Root inports information  */
  const int_T gblNumRootInportBlks = 2;
  const int_T gblNumModelInputs = 2;
  extern rtInportTUtable *gblInportTUtables;
  extern const char *gblInportFileName;
  const int_T gblInportDataTypeIdx[] = { 0, 0 };

  const int_T gblInportDims[] = { 1, 1, 1, 1 } ;

  const int_T gblInportComplex[] = { 0, 0 };

  const int_T gblInportInterpoFlag[] = { 1, 1 };

  const int_T gblInportContinuous[] = { 1, 1 };
}
#include "simstruc.h"
#include "fixedpoint.h"

/* Block signals (auto storage) */
B rtB;

/* Continuous states */
X rtX;

/* Block states (auto storage) */
DW rtDW;

/* External inputs (root inport signals with auto storage) */
ExtU rtU;

/* External outputs (root outports fed by signals with auto storage) */
ExtY rtY;

/* Parent Simstruct */
#ifdef __cplusplus

extern "C" {

#endif

  static SimStruct model_S;
  SimStruct *const rtS = &model_S;

#ifdef __cplusplus

}
#endif

real_T rt_powd_snf(real_T u0, real_T u1)
{
  real_T y;
  real_T tmp;
  real_T tmp_0;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = (rtNaN);
  } else {
    tmp = std::abs(u0);
    tmp_0 = std::abs(u1);
    if (rtIsInf(u1)) {
      if (tmp == 1.0) {
        y = 1.0;
      } else if (tmp > 1.0) {
        if (u1 > 0.0) {
          y = (rtInf);
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = (rtInf);
      }
    } else if (tmp_0 == 0.0) {
      y = 1.0;
    } else if (tmp_0 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = std::sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > std::floor(u1))) {
      y = (rtNaN);
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

/* System initialize for root system: '<Root>' */
extern "C" void MdlInitialize(void)
{
  /* InitializeConditions for Integrator: '<S1>/Integrator' */
  rtX.Integrator_CSTATE[0] = 0.0;

  /* InitializeConditions for Integrator: '<S1>/Integrator1' */
  rtX.Integrator1_CSTATE[0] = 0.0;

  /* InitializeConditions for Integrator: '<S1>/Integrator' */
  rtX.Integrator_CSTATE[1] = 0.0;

  /* InitializeConditions for Integrator: '<S1>/Integrator1' */
  rtX.Integrator1_CSTATE[1] = 0.0;

  /* InitializeConditions for Integrator: '<S1>/Integrator2' */
  rtX.Integrator2_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<Root>/Integrator' */
  rtX.Integrator_CSTATE_f = 0.0;
}

/* Start for root system: '<Root>' */
extern "C" void MdlStart(void)
{
  MdlInitialize();
}

/* Outputs for root system: '<Root>' */
extern "C" void MdlOutputs(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_Fcn1;
  real_T tmp;
  int32_T i;
  int32_T i_0;

  /* Read data from the mat file of inport block */
  if (gblInportFileName != (NULL)) {
    int_T currTimeIdx;
    int_T i;

    /*
     *  Read in data from mat file for root inport i_ext
     */
    if (gblInportTUtables[0].nTimePoints > 0) {
      if (1) {
        {
          real_T time = ssGetTaskTime(rtS,0);
          int k = 1;
          if (gblInportTUtables[0].nTimePoints == 1) {
            k = 0;
          }

          currTimeIdx = rt_getTimeIdx(gblInportTUtables[0].time, time,
            gblInportTUtables[0].nTimePoints,
            gblInportTUtables[0].currTimeIdx,
            1,
            0);
          gblInportTUtables[0].currTimeIdx = currTimeIdx;
          for (i = 0; i < 1; i++) {
            real_T* realPtr1 = (real_T*)gblInportTUtables[0].ur +
              i*gblInportTUtables[0].nTimePoints +currTimeIdx;
            real_T* realPtr2 = realPtr1 + 1*k;
            (void)rt_Interpolate_Datatype(
              realPtr1,
              realPtr2,
              &rtU.i_ext,
              time,
              gblInportTUtables[0].time[currTimeIdx],
              gblInportTUtables[0].time[currTimeIdx + k],
              gblInportTUtables[0].uDataType);
          }
        }
      }
    }

    /*
     *  Read in data from mat file for root inport use_ext
     */
    if (gblInportTUtables[1].nTimePoints > 0) {
      if (1) {
        {
          real_T time = ssGetTaskTime(rtS,0);
          int k = 1;
          if (gblInportTUtables[1].nTimePoints == 1) {
            k = 0;
          }

          currTimeIdx = rt_getTimeIdx(gblInportTUtables[1].time, time,
            gblInportTUtables[1].nTimePoints,
            gblInportTUtables[1].currTimeIdx,
            1,
            0);
          gblInportTUtables[1].currTimeIdx = currTimeIdx;
          for (i = 0; i < 1; i++) {
            real_T* realPtr1 = (real_T*)gblInportTUtables[1].ur +
              i*gblInportTUtables[1].nTimePoints +currTimeIdx;
            real_T* realPtr2 = realPtr1 + 1*k;
            (void)rt_Interpolate_Datatype(
              realPtr1,
              realPtr2,
              &rtU.use_ext,
              time,
              gblInportTUtables[1].time[currTimeIdx],
              gblInportTUtables[1].time[currTimeIdx + k],
              gblInportTUtables[1].uDataType);
          }
        }
      }
    }
  }

  /* end read inport data from file */

  /* Integrator: '<S1>/Integrator' */
  rtB.Integrator[0] = rtX.Integrator_CSTATE[0];

  /* Integrator: '<S1>/Integrator1' */
  rtB.Integrator1[0] = rtX.Integrator1_CSTATE[0];

  /* Integrator: '<S1>/Integrator' */
  rtB.Integrator[1] = rtX.Integrator_CSTATE[1];

  /* Integrator: '<S1>/Integrator1' */
  rtB.Integrator1[1] = rtX.Integrator1_CSTATE[1];

  /* Integrator: '<S1>/Integrator2' */
  rtB.ff = rtX.Integrator2_CSTATE;

  /* Switch: '<S1>/Switch' incorporates:
   *  Inport: '<Root>/i_ext'
   *  Inport: '<Root>/use_ext'
   */
  if (ssIsMajorTimeStep(rtS)) {
    rtDW.Switch_Mode = (rtU.use_ext > 0.0);
  }

  if (rtDW.Switch_Mode) {
    for (i = 0; i < 5; i++) {
      rtB.Switch[i] = rtU.i_ext;
    }
  } else {
    /* SignalConversion: '<S1>/TmpSignal ConversionAtInverse inductanceInport1' */
    rtB.TmpSignalConversionAtInverseind[0] = rtB.Integrator[0];
    rtB.TmpSignalConversionAtInverseind[2] = rtB.Integrator1[0];
    rtB.TmpSignalConversionAtInverseind[1] = rtB.Integrator[1];
    rtB.TmpSignalConversionAtInverseind[3] = rtB.Integrator1[1];
    rtB.TmpSignalConversionAtInverseind[4] = rtB.ff;

    /* Gain: '<S1>/Inverse inductance' */
    for (i = 0; i < 5; i++) {
      rtB.Inverseinductance[i] = 0.0;
      for (i_0 = 0; i_0 < 5; i_0++) {
        rtB.Inverseinductance[i] += rtConstP.Inverseinductance_Gain[5 * i_0 + i]
          * rtB.TmpSignalConversionAtInverseind[i_0];
      }

      rtB.Switch[i] = rtB.Inverseinductance[i];
    }

    /* End of Gain: '<S1>/Inverse inductance' */
  }

  /* End of Switch: '<S1>/Switch' */
  if (ssIsSampleHit(rtS, 1, 0)) {
    /* Step: '<Root>/Step' */
    rtDW.Step_MODE = (ssGetTaskTime(rtS,1) >= 5.0);

    /* Step: '<Root>/Step1' */
    rtDW.Step1_MODE = (ssGetTaskTime(rtS,1) >= 7.0);

    /* Product: '<Root>/Product' incorporates:
     *  Step: '<Root>/Step'
     *  Step: '<Root>/Step1'
     */
    rtB.Product = (real_T)(rtDW.Step_MODE == 1) * (real_T)!(rtDW.Step1_MODE == 1);
  }

  /* Switch: '<Root>/Switch' */
  if (rtB.Product > 0.0) {
    /* Gain: '<Root>/Gain7' */
    rtB.Gain7[0] = 0.1 * rtB.Switch[0];
    rtB.Switch_j[0] = rtB.Gain7[0];

    /* Gain: '<Root>/Gain7' */
    rtB.Gain7[1] = 0.1 * rtB.Switch[1];
    rtB.Switch_j[1] = rtB.Gain7[1];
  } else {
    rtB.Switch_j[0] = rtB.Switch[0];
    rtB.Switch_j[1] = rtB.Switch[1];
  }

  /* End of Switch: '<Root>/Switch' */

  /* Fcn: '<Root>/Fcn' */
  tmp = (rt_powd_snf(rtB.Switch_j[0], 2.0) + rt_powd_snf(rtB.Switch_j[1], 2.0)) /
    3.0;
  if (tmp < 0.0) {
    tmp = -std::sqrt(-tmp);
  } else {
    tmp = std::sqrt(tmp);
  }

  /* End of Fcn: '<Root>/Fcn' */

  /* Gain: '<Root>/Gain1' */
  rtB.Gain1 = 115.0 * tmp;

  /* Outport: '<Root>/vrms_out' */
  rtY.vrms_out = rtB.Gain1;

  /* Sum: '<Root>/Add' incorporates:
   *  Constant: '<Root>/Constant1'
   */
  rtB.Add = 115.0 - rtB.Gain1;

  /* Integrator: '<Root>/Integrator' */
  /* Limited  Integrator  */
  if (ssIsMajorTimeStep(rtS)) {
    if (rtX.Integrator_CSTATE_f >= 1.0) {
      rtX.Integrator_CSTATE_f = 1.0;
    } else {
      if (rtX.Integrator_CSTATE_f <= -1.0) {
        rtX.Integrator_CSTATE_f = -1.0;
      }
    }
  }

  rtB.Integrator_h = rtX.Integrator_CSTATE_f;

  /* End of Integrator: '<Root>/Integrator' */

  /* Gain: '<Root>/Gain' */
  rtB.Gain = 0.001 * rtB.Integrator_h;

  /* Sum: '<Root>/Add1' */
  rtB.Add1 = rtB.Add + rtB.Gain;

  /* Gain: '<Root>/Gain6' */
  rtB.Gain6 = 0.0086956521739130436 * rtB.Add1;

  /* Saturate: '<Root>/Saturation' */
  if (ssIsMajorTimeStep(rtS)) {
    rtDW.Saturation_MODE = rtB.Gain6 >= 1.0 ? 1 : rtB.Gain6 > -1.0 ? 0 : -1;
  }

  rtB.Saturation = rtDW.Saturation_MODE == 1 ? 1.0 : rtDW.Saturation_MODE == -1 ?
    -1.0 : rtB.Gain6;

  /* End of Saturate: '<Root>/Saturation' */

  /* Outport: '<Root>/vf_out' */
  rtY.vf_out = rtB.Saturation;

  /* Outport: '<Root>/if_out' */
  rtY.if_out = rtB.Switch[4];

  /* Fcn: '<Root>/Fcn1' */
  tmp = (rt_powd_snf(rtB.Switch[0], 2.0) + rt_powd_snf(rtB.Switch[1], 2.0)) /
    3.0;
  if (tmp < 0.0) {
    rtb_Fcn1 = -std::sqrt(-tmp);
  } else {
    rtb_Fcn1 = std::sqrt(tmp);
  }

  /* End of Fcn: '<Root>/Fcn1' */

  /* Outport: '<Root>/irms_out' */
  rtY.irms_out = rtb_Fcn1;

  /* Gain: '<S1>/Gain' */
  rtB.Gain_k[0] = 0.018 * rtB.Switch[0];

  /* Gain: '<S1>/rot' */
  rtB.rot[0] = 0.0;
  rtB.rot[0] += 0.0 * rtB.Integrator[0];
  rtB.rot[0] += -rtB.Integrator[1];

  /* Product: '<S1>/Product' */
  rtB.Product_i[0] = rtB.rot[0] * 1.5791367041742974E+6;

  /* Sum: '<S1>/Sum1' */
  rtB.Sum1[0] = (rtB.Switch_j[0] - rtB.Product_i[0]) - rtB.Gain_k[0];

  /* Gain: '<S1>/Gain4' */
  rtB.Gain4[0] = 376.99111843077515 * rtB.Sum1[0];

  /* Gain: '<S1>/damper reistances' */
  rtB.damperreistances[0] = 0.0;
  rtB.damperreistances[0] += 0.02 * rtB.Switch[2];
  rtB.damperreistances[0] += 0.0 * rtB.Switch[3];

  /* Gain: '<S1>/Gain5' */
  rtB.Gain5[0] = -376.99111843077515 * rtB.damperreistances[0];

  /* Gain: '<S1>/Gain' */
  rtB.Gain_k[1] = 0.018 * rtB.Switch[1];

  /* Gain: '<S1>/rot' */
  rtB.rot[1] = 0.0;
  rtB.rot[1] += rtB.Integrator[0];
  rtB.rot[1] += 0.0 * rtB.Integrator[1];

  /* Product: '<S1>/Product' */
  rtB.Product_i[1] = rtB.rot[1] * 1.5791367041742974E+6;

  /* Sum: '<S1>/Sum1' */
  rtB.Sum1[1] = (rtB.Switch_j[1] - rtB.Product_i[1]) - rtB.Gain_k[1];

  /* Gain: '<S1>/Gain4' */
  rtB.Gain4[1] = 376.99111843077515 * rtB.Sum1[1];

  /* Gain: '<S1>/damper reistances' */
  rtB.damperreistances[1] = 0.0;
  rtB.damperreistances[1] += 0.0 * rtB.Switch[2];
  rtB.damperreistances[1] += 0.04 * rtB.Switch[3];

  /* Gain: '<S1>/Gain5' */
  rtB.Gain5[1] = -376.99111843077515 * rtB.damperreistances[1];

  /* Gain: '<S1>/R1' */
  rtB.R1 = 0.001 * rtB.Switch[4];

  /* Sum: '<S1>/Sum' */
  rtB.Sum = rtB.Saturation - rtB.R1;

  /* Gain: '<S1>/Gain6' */
  rtB.Gain6_n = 376.99111843077515 * rtB.Sum;
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
extern "C" void MdlUpdate(int_T tid)
{
  /* Update for Integrator: '<Root>/Integrator' */
  /* 0: INTG_NORMAL     1: INTG_LEAVING_UPPER_SAT  2: INTG_LEAVING_LOWER_SAT */
  /* 3: INTG_UPPER_SAT  4: INTG_LOWER_SAT */
  if (rtX.Integrator_CSTATE_f == 1.0) {
    switch (rtDW.Integrator_MODE) {
     case 3:
      if (rtB.Add < 0.0) {
        ssSetSolverNeedsReset(rtS);
        rtDW.Integrator_MODE = 1;
      }
      break;

     case 1:
      if (rtB.Add >= 0.0) {
        rtDW.Integrator_MODE = 3;
        ssSetSolverNeedsReset(rtS);
      }
      break;

     default:
      ssSetSolverNeedsReset(rtS);
      if (rtB.Add < 0.0) {
        rtDW.Integrator_MODE = 1;
      } else {
        rtDW.Integrator_MODE = 3;
      }
      break;
    }
  } else if (rtX.Integrator_CSTATE_f == -1.0) {
    switch (rtDW.Integrator_MODE) {
     case 4:
      if (rtB.Add > 0.0) {
        ssSetSolverNeedsReset(rtS);
        rtDW.Integrator_MODE = 2;
      }
      break;

     case 2:
      if (rtB.Add <= 0.0) {
        rtDW.Integrator_MODE = 4;
        ssSetSolverNeedsReset(rtS);
      }
      break;

     default:
      ssSetSolverNeedsReset(rtS);
      if (rtB.Add > 0.0) {
        rtDW.Integrator_MODE = 2;
      } else {
        rtDW.Integrator_MODE = 4;
      }
      break;
    }
  } else {
    rtDW.Integrator_MODE = 0;
  }

  /* End of Update for Integrator: '<Root>/Integrator' */
  UNUSED_PARAMETER(tid);
}

/* Derivatives for root system: '<Root>' */
extern "C" void MdlDerivatives(void)
{
  XDot *_rtXdot;
  _rtXdot = ((XDot *) ssGetdX(rtS));

  /* Derivatives for Integrator: '<S1>/Integrator' */
  _rtXdot->Integrator_CSTATE[0] = rtB.Gain4[0];

  /* Derivatives for Integrator: '<S1>/Integrator1' */
  _rtXdot->Integrator1_CSTATE[0] = rtB.Gain5[0];

  /* Derivatives for Integrator: '<S1>/Integrator' */
  _rtXdot->Integrator_CSTATE[1] = rtB.Gain4[1];

  /* Derivatives for Integrator: '<S1>/Integrator1' */
  _rtXdot->Integrator1_CSTATE[1] = rtB.Gain5[1];

  /* Derivatives for Integrator: '<S1>/Integrator2' */
  _rtXdot->Integrator2_CSTATE = rtB.Gain6_n;

  /* Derivatives for Integrator: '<Root>/Integrator' */
  /* 0: INTG_NORMAL     1: INTG_LEAVING_UPPER_SAT  2: INTG_LEAVING_LOWER_SAT */
  /* 3: INTG_UPPER_SAT  4: INTG_LOWER_SAT */
  if ((rtDW.Integrator_MODE != 3) && (rtDW.Integrator_MODE != 4)) {
    _rtXdot->Integrator_CSTATE_f = rtB.Add;
    ((XDis *) ssGetContStateDisabled(rtS))->Integrator_CSTATE_f = false;
  } else {
    /* in saturation */
    _rtXdot->Integrator_CSTATE_f = 0.0;
    if ((rtDW.Integrator_MODE == 3) || (rtDW.Integrator_MODE == 4)) {
      ((XDis *) ssGetContStateDisabled(rtS))->Integrator_CSTATE_f = true;
    }
  }

  /* End of Derivatives for Integrator: '<Root>/Integrator' */
}

/* Projection for root system: '<Root>' */
extern "C" void MdlProjection(void)
{
}

/* ZeroCrossings for root system: '<Root>' */
extern "C" void MdlZeroCrossings(void)
{
  boolean_T anyStateSaturated;

  /* ZeroCrossings for Switch: '<S1>/Switch' incorporates:
   *  ZeroCrossings for Inport: '<Root>/use_ext'
   */
  ((ZCV *) ssGetSolverZcSignalVector(rtS))->Switch_SwitchCond_ZC = rtU.use_ext;

  /* ZeroCrossings for Step: '<Root>/Step' */
  ((ZCV *) ssGetSolverZcSignalVector(rtS))->Step_StepTime_ZC = ssGetT(rtS) - 5.0;

  /* ZeroCrossings for Step: '<Root>/Step1' */
  ((ZCV *) ssGetSolverZcSignalVector(rtS))->Step1_StepTime_ZC = ssGetT(rtS) -
    7.0;

  /* ZeroCrossings for Integrator: '<Root>/Integrator' */
  /* zero crossings for entering into limited region */
  /* 0: INTG_NORMAL     1: INTG_LEAVING_UPPER_SAT  2: INTG_LEAVING_LOWER_SAT */
  /* 3: INTG_UPPER_SAT  4: INTG_LOWER_SAT */
  if ((rtDW.Integrator_MODE == 1) && (rtX.Integrator_CSTATE_f >= 1.0)) {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_IntgUpLimit_ZC = 0.0;
  } else {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_IntgUpLimit_ZC =
      rtX.Integrator_CSTATE_f - 1.0;
  }

  if ((rtDW.Integrator_MODE == 2) && (rtX.Integrator_CSTATE_f <= -1.0)) {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_IntgLoLimit_ZC = 0.0;
  } else {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_IntgLoLimit_ZC =
      rtX.Integrator_CSTATE_f - -1.0;
  }

  /* zero crossings for leaving limited region */
  anyStateSaturated = false;
  if ((rtDW.Integrator_MODE == 3) || (rtDW.Integrator_MODE == 4)) {
    anyStateSaturated = true;
  }

  if (anyStateSaturated) {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_LeaveSaturate_ZC =
      rtB.Add;
  } else {
    ((ZCV *) ssGetSolverZcSignalVector(rtS))->Integrator_LeaveSaturate_ZC = 0.0;
  }

  /* End of ZeroCrossings for Integrator: '<Root>/Integrator' */

  /* ZeroCrossings for Saturate: '<Root>/Saturation' */
  ((ZCV *) ssGetSolverZcSignalVector(rtS))->Saturation_UprLim_ZC = rtB.Gain6 -
    1.0;
  ((ZCV *) ssGetSolverZcSignalVector(rtS))->Saturation_LwrLim_ZC = rtB.Gain6 -
    -1.0;
}

/* Termination for root system: '<Root>' */
extern "C" void MdlTerminate(void)
{
}

/* Function to initialize sizes */
extern "C" void MdlInitializeSizes(void)
{
  ssSetNumContStates(rtS, 6);          /* Number of continuous states */
  ssSetNumPeriodicContStates(rtS, 0);  /* Number of periodic continuous states */
  ssSetNumY(rtS, 4);                   /* Number of model outputs */
  ssSetNumU(rtS, 2);                   /* Number of model inputs */
  ssSetDirectFeedThrough(rtS, 1);      /* The model is direct feedthrough */
  ssSetNumSampleTimes(rtS, 2);         /* Number of sample times */
  ssSetNumBlocks(rtS, 42);             /* Number of blocks */
  ssSetNumBlockIO(rtS, 26);            /* Number of block outputs */
}

/* Function to initialize sample times. */
extern "C" void MdlInitializeSampleTimes(void)
{
  /* task periods */
  ssSetSampleTime(rtS, 0, 0.0);
  ssSetSampleTime(rtS, 1, 0.0);

  /* task offsets */
  ssSetOffsetTime(rtS, 0, 0.0);
  ssSetOffsetTime(rtS, 1, 1.0);
}

/* Function to register the model */
extern "C" SimStruct * sync_mach_cont_sim(void)
{
  static struct _ssMdlInfo mdlInfo;
  (void) memset((char *)rtS, 0,
                sizeof(SimStruct));
  (void) memset((char *)&mdlInfo, 0,
                sizeof(struct _ssMdlInfo));
  ssSetMdlInfoPtr(rtS, &mdlInfo);

  /* timing info */
  {
    static time_T mdlPeriod[NSAMPLE_TIMES];
    static time_T mdlOffset[NSAMPLE_TIMES];
    static time_T mdlTaskTimes[NSAMPLE_TIMES];
    static int_T mdlTsMap[NSAMPLE_TIMES];
    static int_T mdlSampleHits[NSAMPLE_TIMES];
    static boolean_T mdlTNextWasAdjustedPtr[NSAMPLE_TIMES];
    static int_T mdlPerTaskSampleHits[NSAMPLE_TIMES * NSAMPLE_TIMES];
    static time_T mdlTimeOfNextSampleHit[NSAMPLE_TIMES];

    {
      int_T i;
      for (i = 0; i < NSAMPLE_TIMES; i++) {
        mdlPeriod[i] = 0.0;
        mdlOffset[i] = 0.0;
        mdlTaskTimes[i] = 0.0;
        mdlTsMap[i] = i;
        mdlSampleHits[i] = 1;
      }
    }

    ssSetSampleTimePtr(rtS, &mdlPeriod[0]);
    ssSetOffsetTimePtr(rtS, &mdlOffset[0]);
    ssSetSampleTimeTaskIDPtr(rtS, &mdlTsMap[0]);
    ssSetTPtr(rtS, &mdlTaskTimes[0]);
    ssSetSampleHitPtr(rtS, &mdlSampleHits[0]);
    ssSetTNextWasAdjustedPtr(rtS, &mdlTNextWasAdjustedPtr[0]);
    ssSetPerTaskSampleHitsPtr(rtS, &mdlPerTaskSampleHits[0]);
    ssSetTimeOfNextSampleHitPtr(rtS, &mdlTimeOfNextSampleHit[0]);
  }

  ssSetSolverMode(rtS, SOLVER_MODE_SINGLETASKING);

  /*
   * initialize model vectors and cache them in SimStruct
   */

  /* block I/O */
  {
    ssSetBlockIO(rtS, ((void *) &rtB));
    (void) memset(((void *) &rtB), 0,
                  sizeof(B));
  }

  /* external inputs */
  {
    ssSetU(rtS, ((void*) &rtU));
    (void)memset((void *)&rtU, 0, sizeof(ExtU));
  }

  /* external outputs */
  {
    ssSetY(rtS, &rtY);
    (void) memset((void *)&rtY, 0,
                  sizeof(ExtY));
  }

  /* states (continuous)*/
  {
    real_T *x = (real_T *) &rtX;
    ssSetContStates(rtS, x);
    (void) memset((void *)x, 0,
                  sizeof(X));
  }

  /* states (dwork) */
  {
    void *dwork = (void *) &rtDW;
    ssSetRootDWork(rtS, dwork);
    (void) memset(dwork, 0,
                  sizeof(DW));
  }

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    ssSetModelMappingInfo(rtS, &dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;
  }

  /* Model specific registration */
  ssSetRootSS(rtS, rtS);
  ssSetVersion(rtS, SIMSTRUCT_VERSION_LEVEL2);
  ssSetModelName(rtS, "sync_mach_cont_sim");
  ssSetPath(rtS, "sync_mach_cont_sim");
  ssSetTStart(rtS, 0.0);
  ssSetTFinal(rtS, 10.0);

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    ssSetRTWLogInfo(rtS, &rt_DataLoggingInfo);
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(ssGetRTWLogInfo(rtS), (NULL));
    rtliSetLogXSignalPtrs(ssGetRTWLogInfo(rtS), (NULL));
    rtliSetLogT(ssGetRTWLogInfo(rtS), "tout");
    rtliSetLogX(ssGetRTWLogInfo(rtS), "");
    rtliSetLogXFinal(ssGetRTWLogInfo(rtS), "");
    rtliSetLogVarNameModifier(ssGetRTWLogInfo(rtS), "rt_");
    rtliSetLogFormat(ssGetRTWLogInfo(rtS), 4);
    rtliSetLogMaxRows(ssGetRTWLogInfo(rtS), 0);
    rtliSetLogDecimation(ssGetRTWLogInfo(rtS), 1);
    rtliSetLogY(ssGetRTWLogInfo(rtS), "");
    rtliSetLogYSignalInfo(ssGetRTWLogInfo(rtS), (NULL));
    rtliSetLogYSignalPtrs(ssGetRTWLogInfo(rtS), (NULL));
  }

  {
    static struct _ssStatesInfo2 statesInfo2;
    ssSetStatesInfo2(rtS, &statesInfo2);
  }

  {
    static ssPeriodicStatesInfo periodicStatesInfo;
    ssSetPeriodicStatesInfo(rtS, &periodicStatesInfo);
  }

  {
    static ssSolverInfo slvrInfo;
    static boolean_T contStatesDisabled[6];
    static real_T absTol[6] = { 1.0E-6, 1.0E-6, 1.0E-6, 1.0E-6, 1.0E-6, 1.0E-6 };

    static uint8_T absTolControl[6] = { 0U, 0U, 0U, 0U, 0U, 0U };

    static uint8_T zcAttributes[8] = { (ZC_EVENT_ALL), (ZC_EVENT_ALL_UP),
      (ZC_EVENT_ALL_UP), (ZC_EVENT_ALL_UP), (ZC_EVENT_ALL_DN), (ZC_EVENT_ALL),
      (ZC_EVENT_ALL), (ZC_EVENT_ALL) };

    static ssNonContDerivSigInfo nonContDerivSigInfo[1] = {
      { 1*sizeof(real_T), (char*)(&rtB.Product), (NULL) }
    };

    ssSetSolverRelTol(rtS, 0.001);
    ssSetStepSize(rtS, 0.0);
    ssSetMinStepSize(rtS, 0.0);
    ssSetMaxNumMinSteps(rtS, -1);
    ssSetMinStepViolatedError(rtS, 0);
    ssSetMaxStepSize(rtS, 0.2);
    ssSetSolverMaxOrder(rtS, -1);
    ssSetSolverRefineFactor(rtS, 1);
    ssSetOutputTimes(rtS, (NULL));
    ssSetNumOutputTimes(rtS, 0);
    ssSetOutputTimesOnly(rtS, 0);
    ssSetOutputTimesIndex(rtS, 0);
    ssSetZCCacheNeedsReset(rtS, 1);
    ssSetDerivCacheNeedsReset(rtS, 0);
    ssSetNumNonContDerivSigInfos(rtS, 1);
    ssSetNonContDerivSigInfos(rtS, nonContDerivSigInfo);
    ssSetSolverInfo(rtS, &slvrInfo);
    ssSetSolverName(rtS, "ode23tb");
    ssSetVariableStepSolver(rtS, 1);
    ssSetSolverConsistencyChecking(rtS, 0);
    ssSetSolverAdaptiveZcDetection(rtS, 0);
    ssSetSolverRobustResetMethod(rtS, 0);
    ssSetAbsTolVector(rtS, absTol);
    ssSetAbsTolControlVector(rtS, absTolControl);
    ssSetSolverAbsTol_Obsolete(rtS, absTol);
    ssSetSolverAbsTolControl_Obsolete(rtS, absTolControl);
    ssSetSolverStateProjection(rtS, 0);
    ssSetSolverMassMatrixType(rtS, (ssMatrixType)0);
    ssSetSolverMassMatrixNzMax(rtS, 0);
    ssSetModelOutputs(rtS, MdlOutputs);
    ssSetModelLogData(rtS, rt_UpdateTXYLogVars);
    ssSetModelLogDataIfInInterval(rtS, rt_UpdateTXXFYLogVars);
    ssSetModelUpdate(rtS, MdlUpdate);
    ssSetModelDerivatives(rtS, MdlDerivatives);
    ssSetSolverZcSignalAttrib(rtS, zcAttributes);
    ssSetSolverNumZcSignals(rtS, 8);
    ssSetModelZeroCrossings(rtS, MdlZeroCrossings);
    ssSetSolverConsecutiveZCsStepRelTol(rtS, 2.8421709430404007E-13);
    ssSetSolverMaxConsecutiveZCs(rtS, 1000);
    ssSetSolverConsecutiveZCsError(rtS, 2);
    ssSetSolverMaskedZcDiagnostic(rtS, 1);
    ssSetSolverIgnoredZcDiagnostic(rtS, 1);
    ssSetSolverMaxConsecutiveMinStep(rtS, 1);
    ssSetSolverShapePreserveControl(rtS, 2);
    ssSetTNextTid(rtS, INT_MIN);
    ssSetTNext(rtS, rtMinusInf);
    ssSetSolverNeedsReset(rtS);
    ssSetNumNonsampledZCs(rtS, 8);
    ssSetContStateDisabled(rtS, contStatesDisabled);
    ssSetSolverMaxConsecutiveMinStep(rtS, 1);
  }

  ssSetChecksumVal(rtS, 0, 1584842628U);
  ssSetChecksumVal(rtS, 1, 3345961960U);
  ssSetChecksumVal(rtS, 2, 2278888954U);
  ssSetChecksumVal(rtS, 3, 1970736456U);
  return rtS;
}
