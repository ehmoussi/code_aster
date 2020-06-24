! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine utgtme(nbarg, nomarg, valarg, iret)
    implicit none
#include "asterc/loisem.h"
#include "asterc/mempid.h"
#include "asterfort/assert.h"
    integer :: nbarg, iret
    character(len=8) :: nomarg(*)
    real(kind=8) :: valarg(*)
! person_in_charge: mathieu.courtois at edf.fr
! ----------------------------------------------------------------------
!
!   Return the values related to the parameters names given with `nomarg`.
!
!   NB: VmPeak/VmSize may be unsupported on some platforms.
!       The caller must check that the returned values are not null.
!
!   In  nbarg           Number of requested parameters
!   In  nomarg(nbarg)   Parameters names
!   Out valarg(nbarg)   Returned values for parameters in MB
!   Out iret            Exit code: 0 if all parameters are found, <0 otherwise.
!
! ----------------------------------------------------------------------
    real(kind=8) :: svuse, smxuse
    common /statje/ svuse,smxuse
    real(kind=8) :: mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio
    common /r8dyje/ mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio(2)
    real(kind=8) :: vmumps, vpetsc, rlqmem, vminit, vmjdc
    common /msolve/ vmumps,vpetsc,rlqmem,vminit,vmjdc
! ----------------------------------------------------------------------
    integer :: k, iv(2), ival, lois
    character(len=8) :: nom
! ----------------------------------------------------------------------
    iret = 0
    ASSERT(nbarg .ge.1)
    lois = loisem()
    iv(1) = 0
    iv(2) = 0
    ival = mempid(iv)
    ASSERT(ival .eq. 0)
!
    do k = 1, nbarg
!
        nom = nomarg(k)
        if (nom .eq. 'VMPEAK') then
!
! ----- Pic memoire totale
!
            valarg(k) = dble(iv(2))/1024
!
        else if (nom .eq. 'VMSIZE') then
!
! ----- Memoire instantannee
!
            valarg(k) = dble(iv(1))/1024
!
        else if (nom .eq. 'LIMIT_JV') then
!
! ----- Limite memoire jeveux (modifiee par jermxd)
!
            valarg(k) = vmxdyn*lois/(1024*1024)
!
        else if (nom .eq. 'COUR_JV ') then
!
! ----- Consommation memoire jeveux courante (cumul des allocations)
!
            valarg(k) = mcdyn*lois/(1024*1024)
!
        else if (nom .eq. 'CMAX_JV ') then
!
! ----- Consommation maximum memoire jeveux (max des cumuls)
!
            valarg(k) = mxdyn/(1024*1024)
!
        else if (nom .eq. 'CMXU_JV ') then
!
! ----- Consommation maximum memoire jeveux
!       objets jeveux utilises
!
            valarg(k) = (smxuse*lois)/(1024*1024)
!
        else if (nom .eq. 'CUSE_JV ') then
!
! ----- Consommation memoire courante jeveux
!       objets jeveux utilises
!
            valarg(k) = (svuse*lois)/(1024*1024)
!
        else if (nom .eq. 'MEM_TOTA') then
!
! ----- Limite memoire allouee lors de l'execution
!
            valarg(k) = vmet*lois/(1024*1024)
!
        else if (nom .eq. 'MEM_MUMP') then
!
! ----- Consommation memoire du solveur mumps
!
            valarg(k) = vmumps/(1024*1024)
!
        else if (nom .eq. 'MEM_PETS') then
!
! ----- Consommation memoire du solveur petsc
!
            valarg(k) = vpetsc/(1024*1024)
!
        else if (nom .eq. 'MEM_INIT') then
!
! ----- Consommation memoire de l'initialisation
!
            valarg(k) = vminit/(1024*1024)
!
        else if (nom .eq. 'RLQ_MEM') then
!
! ------ Estimation du reliquat memoire
!
            valarg(k) = rlqmem/(1024*1024)
!
        else
            iret = iret - 1
        endif
!
    end do
!
end subroutine
