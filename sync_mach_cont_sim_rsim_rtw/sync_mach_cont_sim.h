/*
 * sync_mach_cont_sim.h
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

#ifndef RTW_HEADER_sync_mach_cont_sim_h_
#define RTW_HEADER_sync_mach_cont_sim_h_
#include <stddef.h>
#include <cmath>
#include <math.h>
#include <string.h>
#ifndef sync_mach_cont_sim_COMMON_INCLUDES_
# define sync_mach_cont_sim_COMMON_INCLUDES_
#include <stdlib.h>
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rsim.h"
#include "rt_logging.h"
#include "dt_info.h"
#endif                                 /* sync_mach_cont_sim_COMMON_INCLUDES_ */

#include "sync_mach_cont_sim_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "rt_nonfinite.h"
#include "rt_defines.h"
#include "rtGetInf.h"
#define MODEL_NAME                     sync_mach_cont_sim
#define NSAMPLE_TIMES                  (2)                       /* Number of sample times */
#define NINPUTS                        (2)                       /* Number of model inputs */
#define NOUTPUTS                       (4)                       /* Number of model outputs */
#define NBLOCKIO                       (26)                      /* Number of data output port signals */
#define NUM_ZC_EVENTS                  (0)                       /* Number of zero-crossing events */
#ifndef NCSTATES
# define NCSTATES                      (6)                       /* Number of continuous states */
#elif NCSTATES != 6
# error Invalid specification of NCSTATES defined in compiler command
#endif

#ifndef rtmGetDataMapInfo
# define rtmGetDataMapInfo(rtm)        (NULL)
#endif

#ifndef rtmSetDataMapInfo
# define rtmSetDataMapInfo(rtm, val)
#endif

/* Block signals (auto storage) */
typedef struct {
  real_T Integrator[2];                /* '<S1>/Integrator' */
  real_T Integrator1[2];               /* '<S1>/Integrator1' */
  real_T ff;                           /* '<S1>/Integrator2' */
  real_T Switch[5];                    /* '<S1>/Switch' */
  real_T Product;                      /* '<Root>/Product' */
  real_T Switch_j[2];                  /* '<Root>/Switch' */
  real_T Gain1;                        /* '<Root>/Gain1' */
  real_T Add;                          /* '<Root>/Add' */
  real_T Integrator_h;                 /* '<Root>/Integrator' */
  real_T Gain;                         /* '<Root>/Gain' */
  real_T Add1;                         /* '<Root>/Add1' */
  real_T Gain6;                        /* '<Root>/Gain6' */
  real_T Saturation;                   /* '<Root>/Saturation' */
  real_T Gain_k[2];                    /* '<S1>/Gain' */
  real_T rot[2];                       /* '<S1>/rot' */
  real_T Product_i[2];                 /* '<S1>/Product' */
  real_T Sum1[2];                      /* '<S1>/Sum1' */
  real_T Gain4[2];                     /* '<S1>/Gain4' */
  real_T damperreistances[2];          /* '<S1>/damper reistances' */
  real_T Gain5[2];                     /* '<S1>/Gain5' */
  real_T R1;                           /* '<S1>/R1' */
  real_T Sum;                          /* '<S1>/Sum' */
  real_T Gain6_n;                      /* '<S1>/Gain6' */
  real_T TmpSignalConversionAtInverseind[5];
  real_T Inverseinductance[5];         /* '<S1>/Inverse inductance' */
  real_T Gain7[2];                     /* '<Root>/Gain7' */
} B;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData;
  } Scope_PWORK;                       /* '<Root>/Scope' */

  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  struct {
    void *LoggedData;
  } Scope2_PWORK;                      /* '<Root>/Scope2' */

  int_T Step_MODE;                     /* '<Root>/Step' */
  int_T Step1_MODE;                    /* '<Root>/Step1' */
  int_T Integrator_MODE;               /* '<Root>/Integrator' */
  int_T Saturation_MODE;               /* '<Root>/Saturation' */
  boolean_T Switch_Mode;               /* '<S1>/Switch' */
} DW;

/* Continuous states (auto storage) */
typedef struct {
  real_T Integrator_CSTATE[2];         /* '<S1>/Integrator' */
  real_T Integrator1_CSTATE[2];        /* '<S1>/Integrator1' */
  real_T Integrator2_CSTATE;           /* '<S1>/Integrator2' */
  real_T Integrator_CSTATE_f;          /* '<Root>/Integrator' */
} X;

/* State derivatives (auto storage) */
typedef struct {
  real_T Integrator_CSTATE[2];         /* '<S1>/Integrator' */
  real_T Integrator1_CSTATE[2];        /* '<S1>/Integrator1' */
  real_T Integrator2_CSTATE;           /* '<S1>/Integrator2' */
  real_T Integrator_CSTATE_f;          /* '<Root>/Integrator' */
} XDot;

/* State disabled  */
typedef struct {
  boolean_T Integrator_CSTATE[2];      /* '<S1>/Integrator' */
  boolean_T Integrator1_CSTATE[2];     /* '<S1>/Integrator1' */
  boolean_T Integrator2_CSTATE;        /* '<S1>/Integrator2' */
  boolean_T Integrator_CSTATE_f;       /* '<Root>/Integrator' */
} XDis;

/* Continuous State Absolute Tolerance  */
typedef struct {
  real_T Integrator_CSTATE[2];         /* '<S1>/Integrator' */
  real_T Integrator1_CSTATE[2];        /* '<S1>/Integrator1' */
  real_T Integrator2_CSTATE;           /* '<S1>/Integrator2' */
  real_T Integrator_CSTATE_f;          /* '<Root>/Integrator' */
} CStateAbsTol;

/* Zero-crossing (trigger) state */
typedef struct {
  real_T Switch_SwitchCond_ZC;         /* '<S1>/Switch' */
  real_T Step_StepTime_ZC;             /* '<Root>/Step' */
  real_T Step1_StepTime_ZC;            /* '<Root>/Step1' */
  real_T Integrator_IntgUpLimit_ZC;    /* '<Root>/Integrator' */
  real_T Integrator_IntgLoLimit_ZC;    /* '<Root>/Integrator' */
  real_T Integrator_LeaveSaturate_ZC;  /* '<Root>/Integrator' */
  real_T Saturation_UprLim_ZC;         /* '<Root>/Saturation' */
  real_T Saturation_LwrLim_ZC;         /* '<Root>/Saturation' */
} ZCV;

/* Constant parameters (auto storage) */
typedef struct {
  /* Expression: L_1
   * Referenced by: '<S1>/Inverse inductance'
   */
  real_T Inverseinductance_Gain[25];
} ConstP;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T i_ext;                        /* '<Root>/i_ext' */
  real_T use_ext;                      /* '<Root>/use_ext' */
} ExtU;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T vrms_out;                     /* '<Root>/vrms_out' */
  real_T vf_out;                       /* '<Root>/vf_out' */
  real_T if_out;                       /* '<Root>/if_out' */
  real_T irms_out;                     /* '<Root>/irms_out' */
} ExtY;

/* External data declarations for dependent source files */
#ifdef __cplusplus

extern "C" {

#endif

  extern const char *RT_MEMORY_ALLOCATION_ERROR;

#ifdef __cplusplus

}
#endif

extern B rtB;                          /* block i/o */
extern X rtX;                          /* states (continuous) */
extern DW rtDW;                        /* states (dwork) */
extern ExtU rtU;                       /* external inputs */
extern ExtY rtY;                       /* external outputs */

/* Constant parameters (auto storage) */
extern const ConstP rtConstP;

#ifdef __cplusplus

extern "C" {

#endif

  /* Simulation Structure */
  extern SimStruct *const rtS;

#ifdef __cplusplus

}
#endif

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<Root>/Display1' : Unused code path elimination
 * Block '<Root>/Display2' : Unused code path elimination
 * Block '<Root>/Display4' : Unused code path elimination
 * Block '<Root>/Display5' : Unused code path elimination
 * Block '<S1>/Dot Product1' : Unused code path elimination
 * Block '<S1>/rot1' : Unused code path elimination
 * Block '<Root>/Gain2' : Eliminated nontunable gain of 1
 * Block '<Root>/Gain3' : Eliminated nontunable gain of 1
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'sync_mach_cont_sim'
 * '<S1>'   : 'sync_mach_cont_sim/SM'
 */

/* user code (bottom of header file) */
#ifdef __cplusplus

extern "C" {

#endif

  extern const int_T gblNumToFiles;
  extern const int_T gblNumFrFiles;
  extern const int_T gblNumFrWksBlocks;
  extern rtInportTUtable *gblInportTUtables;
  extern const char *gblInportFileName;
  extern const int_T gblNumRootInportBlks;
  extern const int_T gblNumModelInputs;
  extern const int_T gblInportDataTypeIdx[];
  extern const int_T gblInportDims[];
  extern const int_T gblInportComplex[];
  extern const int_T gblInportInterpoFlag[];
  extern const int_T gblInportContinuous[];

#ifdef __cplusplus

}
#endif
#endif                                 /* RTW_HEADER_sync_mach_cont_sim_h_ */
