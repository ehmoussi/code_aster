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

subroutine lcjplc(loi, mod, angmas, imat, nmat,&
                  mater, timed, timef, comp, nbcomm,&
                  cpmono, pgl, nfs, nsg, toutms,&
                  hsr, nr, nvi, epsd, deps,&
                  itmax, toler, sigf, vinf, sigd,&
                  vind, dsde, drdy, option, iret,&
                  fami, kpg, ksp)
! aslint: disable=W1504
    implicit none
!       MATRICE SYMETRIQUE DE COMPORTEMENT TANGENT ELASTO-PLASTIQUE OU
!       VISCO-PLASTIQUE COHERENT A T+DT OU T
!       COHERENT A T+DT OU T
!       IN  FAMI   :  FAMILLE DES POINTS DE GAUSS
!           KPG    :  NUMERO DU POINT DE GAUSS
!           KSP    :  NUMERO DU SOUS POINT DE GAUSS
!           LOI    :  MODELE DE COMPORTEMENT
!           MOD    :  TYPE DE MODELISATION
!           NMAT   :  DIMENSION MATER
!           MATER  :  COEFFICIENTS MATERIAU
!       OUT DSDE   :  MATRICE DE COMPORTEMENT TANGENT = DSIG/DEPS
!       ----------------------------------------------------------------
#include "asterfort/cvmjpl.h"
#include "asterfort/hujopt.h"
#include "asterfort/lcmmjp.h"
#include "asterfort/lcoptg.h"
#include "asterfort/lkijpl.h"
#include "asterfort/srijpl.h"
    integer :: imat, nmat, nr, nvi, itmax, iret, nfs, nsg, ndt, ndi, n2
    integer :: kpg, ksp
    real(kind=8) :: dsde(6, 6), epsd(*), deps(*), toler, angmas(3)
    real(kind=8) :: mater(nmat, 2)
    real(kind=8) :: toutms(nfs, nsg, 6), hsr(nsg, nsg)
    character(len=*) :: fami    
    character(len=8) :: mod
    character(len=16) :: loi, option
    common /tdim/   ndt  , ndi
!
    integer :: nbcomm(nmat, 3)
    real(kind=8) :: sigf(*), sigd(*), vind(*), vinf(*), timed, timef, pgl(3, 3)
    real(kind=8) :: drdy(nr, nr)
    character(len=16) :: comp(*)
    character(len=24) :: cpmono(5*nmat+1)
!       ----------------------------------------------------------------
    iret=0
    if (loi(1:9) .eq. 'VISCOCHAB') then
        call cvmjpl(mod, nmat, mater, timed, timef,&
                    epsd, deps, sigf, vinf, sigd,&
                    vind, nvi, nr, dsde)
    else if (loi(1:8) .eq. 'MONOCRIS') then
        call lcmmjp(mod, nmat, mater, timed, timef,&
                    comp, nbcomm, cpmono, pgl, nfs,&
                    nsg, toutms, hsr, nr, nvi, sigd,&
                    itmax, toler, vinf, vind, dsde,&
                    drdy, option, iret)
    else if (loi(1:4) .eq. 'LETK') then
        call lkijpl(nmat, mater, sigf, nr, drdy,&
                    dsde)
    else if (loi(1:3) .eq. 'LKR') then
        call srijpl(nmat,mater,sigf,nr,drdy,dsde)
    else if (loi.eq.'HAYHURST') then
        n2=nr-ndt
        call lcoptg(nmat, mater, nr, n2, drdy,&
                    0, dsde, iret)
    else if (loi(1:6) .eq. 'HUJEUX') then
        call hujopt(fami, kpg, ksp, mod, angmas,&
                    imat, nmat, mater, nvi, vinf,&
                    nr, drdy, sigf, dsde, iret)
    else
        n2=nr-ndt
        call lcoptg(nmat, mater, nr, n2, drdy,&
                    1, dsde, iret)
    endif
!
end subroutine
