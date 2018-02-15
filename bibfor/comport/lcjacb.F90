! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine lcjacb(fami, kpg, ksp, rela_comp, mod,&
                  nmat, materd, materf, timed, timef,&
                  yf, deps, itmax, toler, nbcomm,&
                  cpmono, pgl, nfs, nsg, toutms,&
                  hsr, nr, nvi, vind,&
                  vinf, epsd, yd, dy, ye,&
                  crit, indi, vind1, bnews, mtrac,&
                  drdy, iret)
! aslint: disable=W1504
    implicit none
!       CALCUL DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY(DY)
!       IN  FAMI   :  FAMILLE DES POINTS DE GAUSS
!           KPG    :  NUMERO DU POINT DE GAUSS
!           KSP    :  NUMERO DU SOUS POINT DE GAUSS
!           LOI    :  MODELE DE COMPORTEMENT
!           MOD    :  TYPE DE MODELISATION
!           IMAT   :  ADRESSE DU MATERIAU CODE
!           NMAT   :  DIMENSION MATER
!           MATERD :  COEFFICIENTS MATERIAU A T
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           YF     :  VARIABLES A T + DT =    ( SIGF  VINF  (EPS3F)  )
!           TOLER  :  TOLERANCE DE CONVERGENCE LOCALE
!           DEPS   :  INCREMENT DE DEFORMATION
!           ITMAX  :  NOMBRE MAXI D'ITERATIONS LOCALES
!           TIMED  :  INSTANT  T
!           TIMEF  :  INSTANT  T+DT
!           NBCOMM :  INCIDES DES COEF MATERIAU monocristal
!           CPMONO :  NOM DES COMPORTEMENTS monocristal
!           PGL    :  MATRICE DE PASSAGE
!           TOUTMS :  TENSEURS D'ORIENTATION monocristal
!           HSR    :  MATRICE D'INTERACTION monocristal
!           NR     :  DIMENSION DECLAREE DRDY
!           COMP   :  COMPOR - LOI ET TYPE DE DEFORMATION
!           NVI    :  NOMBRE DE VARIABLES INTERNES
!           VIND   :  VARIABLE INTERNES A T
!           VINF   :  VARIABLE INTERNES A T+DT
!           EPSD   :  DEFORMATION A T
!           YD     :  VARIABLES A T   = ( SIGD  VARD  ) A T
!           DY     :  SOLUTION           =    ( DSIG  DVIN  (DEPS3)  )
!           CRIT   :  CRITERES LOCAUX
!           INDI   :  MECANISMES POTENTIEL ACTIFS (HUJEUX)
!           VIND1  :  VARIABLES INTERNES D'ORIGINE (HUJEUX)
!           YE     :  VECTEUR SOLUTION APRES LCINIT
!           BNEWS  :  INDICATEURS LIES A LA TRACTION (HUJEUX)
!           MTRAC  :  INDICATEUR LIE A LA TRACTION (HUJEUX - BIS)
!       OUT DRDY   :  JACOBIEN DU SYSTEME NON LINEAIRE
!           IRET   :  CODE RETOUR
!       ----------------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/cvmjac.h"
#include "asterfort/hayjac.h"
#include "asterfort/hujjac.h"
#include "asterfort/irrjac.h"
#include "asterfort/lcmmja.h"
#include "asterfort/lkijac.h"
#include "asterfort/srijac.h"
    integer :: nr, nmat, kpg, ksp, itmax, iret, nvi, nfs, nsg
    integer :: indi(7)
    real(kind=8) :: deps(*), epsd(*), toler, crit(*)
    real(kind=8) :: drdy(nr, nr), yf(nr), dy(nr), yd(nr), vind1(nvi)
    real(kind=8) :: ye(nr)
!
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: timed, timef, vind(*), vinf(*)
    real(kind=8) :: toutms(nfs, nsg, 6), hsr(nsg, nsg)
!
    character(len=*) :: fami
    character(len=8) :: mod
    character(len=16) :: rela_comp
!
    integer :: nbcomm(nmat, 3)
    real(kind=8) :: pgl(3, 3)
    character(len=24) :: cpmono(5*nmat+1)
!
    aster_logical :: bnews(3), mtrac
!       ----------------------------------------------------------------
!
    iret=0
    if (rela_comp(1:9) .eq. 'VISCOCHAB') then
        call cvmjac(mod, nmat, materf, timed, timef,&
                    yf, dy, nr, epsd, deps,&
                    drdy)
!
    else if (rela_comp(1:8) .eq. 'MONOCRIS') then
        call lcmmja(mod, nmat, materf, timed,&
                    timef, itmax, toler, nbcomm, cpmono,&
                    pgl, nfs, nsg, toutms, hsr,&
                    nr, nvi, vind, deps, yf,&
                    yd, dy, drdy, iret)
!
    else if (rela_comp(1:7) .eq. 'IRRAD3M') then
        call irrjac(fami, kpg, ksp, mod, nmat,&
                    materf, yf, dy, nr, drdy)
!
    else if (rela_comp(1:4) .eq. 'LETK') then
        call lkijac(mod, nmat, materf, timed, timef,&
                    yf, deps, nr, nvi, vind,&
                    vinf, yd, dy, drdy, iret)
!
    else if (rela_comp(1:3) .eq. 'LKR') then
        call srijac(nmat,materf,timed,timef,&
                    yf,deps,nr,nvi,vind,&
                    vinf,yd,drdy)
!
    else if (rela_comp(1:8) .eq. 'HAYHURST') then
        call hayjac(mod, nmat, materf(1, 1), materf(1, 2), timed,&
                    timef, yf, deps, nr, nvi,&
                    vind, vinf, yd, dy, crit,&
                    drdy, iret)
!
    else if (rela_comp(1:6) .eq. 'HUJEUX') then
        call hujjac(mod, nmat, materf, indi, deps,&
                    nr, yd, yf, ye, nvi,&
                    vind, vind1, vinf, drdy, bnews,&
                    mtrac, iret)
!
    endif
!
end subroutine
