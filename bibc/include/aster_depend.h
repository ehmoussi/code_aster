/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

#ifndef ASTER_DEPEND_H
#define ASTER_DEPEND_H

/*
 * Exactly one of _POSIX and _WINDOWS must be defined, they are exclusive.
 *
 * In the source code, only use _POSIX or _WINDOWS and, when required, _USE_64_BITS.
 *
 * The only platform name used is SOLARIS in the signal features.
 *
 */

#include "asterc_config.h"

/* test required value */
#if (! defined _POSIX) && (! defined _WINDOWS)
#   error ERROR _POSIX or _WINDOWS is required
#endif
#if (defined _POSIX) && (defined _WINDOWS)
#   error ERROR only one of _POSIX or _WINDOWS, not both
#endif

#if (defined LINUX) || (defined LINUX64)
#   define GNU_LINUX
#endif

#if defined DARWIN64
#   define DARWIN
#endif

#if (defined FREEBSD64) || (defined __FreeBSD__)
#   define FREEBSD
#endif

#if (defined SOLARIS64)
#   define SOLARIS
#endif

/* MS Windows platforms */
#if (defined _WINDOWS)

/* win64 - use LLP64 model */
#   ifdef _USE_64_BITS
#       define _STRLEN_AT_END
#       define _USE_LONG_LONG_INT
#       define ASTER_INT_SIZE       8
#       define ASTER_REAL8_SIZE     8
#       define ASTERC_FORTRAN_INT   long long
#   endif

/* stdcall must be defined explicitly because it does not seem required anywhere */
#   define _STRLEN_AT_END

#else
/* Linux & Unix platforms */
#   define _STRLEN_AT_END

/* end platforms type */
#endif

#ifdef _USE_64_BITS
#   define INTEGER_NB_CHIFFRES_SIGNIFICATIFS 19
#   define REAL_NB_CHIFFRES_SIGNIFICATIFS    16
#else
#   define INTEGER_NB_CHIFFRES_SIGNIFICATIFS  9
#   define REAL_NB_CHIFFRES_SIGNIFICATIFS    16
#endif

#define STRING_SIZE         ASTERC_STRING_SIZE
#define ASTERINTEGER4       ASTERC_FORTRAN_INT4
#define ASTERINTEGER        ASTERC_FORTRAN_INT
#define ASTERDOUBLE         ASTERC_FORTRAN_REAL8
#define ASTERREAL4          ASTERC_FORTRAN_REAL4

/* flags d'optimisation */
/* taille de bloc dans MULT_FRONT */
#ifdef _USE_64_BITS
#   define __OPT_TAILLE_BLOC_MULT_FRONT__ 96
#else
#   define __OPT_TAILLE_BLOC_MULT_FRONT__ 32
#endif

#ifndef OPT_TAILLE_BLOC_MULT_FRONT
#   define OPT_TAILLE_BLOC_MULT_FRONT __OPT_TAILLE_BLOC_MULT_FRONT__
#endif

/* Comportement par défaut des FPE dans matfpe pour les blas/lapack */
/* On non GNU/Linux systems, FPE are always enabled */
#ifdef GNU_LINUX
#   ifndef _ENABLE_MATHLIB_FPE
#       ifndef _DISABLE_MATHLIB_FPE
#           define _DISABLE_MATHLIB_FPE
#       endif
#   else
#       undef _DISABLE_MATHLIB_FPE
#   endif
#else
#   undef _DISABLE_MATHLIB_FPE
#endif /* GNU_LINUX */

/* Valeurs par défaut pour les répertoires */
#ifndef REP_MAT
#   define REP_MAT "/aster/materiau/"
#endif

#ifndef REP_OUT
#   define REP_OUT "/aster/outils/"
#endif

#ifndef REP_DON
#   define REP_DON "/aster/donnees/"
#endif

#endif
