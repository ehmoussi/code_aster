! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine utptme(nomarg, valarg, iret)
    implicit none
    character(len=8), intent(in) :: nomarg
    real(kind=8), intent(in) :: valarg
    integer, intent(out) :: iret
! person_in_charge: j-pierre.lefebvre at edf.fr
! ----------------------------------------------------------------------
!     Affecte la valeur associée au nom nomarg du paramètre mémoire en Mo
! in  nomarg  : nom du paramètre
! in  valarg  : valeur du paramètre
! out iret    : code retour
!                =0 la valeur a été affectée
!               !=0 la valeur est invalide
!
    real(kind=8) :: mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio
    common /r8dyje/ mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio(2)
    real(kind=8) :: vmumps, vpetsc, rlqmem, vminit, vmjdc
    common /msolve/ vmumps,vpetsc,rlqmem,vminit,vmjdc
! ----------------------------------------------------------------------
    iret = 0
    if (nomarg .eq. 'MEM_TOTA') then
!
! --------- LIMITE MEMOIRE ALLOUEE LORS DE L'EXECUTION
!
        vmet = valarg*(1024*1024)
!
!
    else if (nomarg .eq. 'RLQ_MEM') then
!
! -------- RELIQUAT MEMOIRE (CONSOMMATION HORS JEVEUX ET SOLVEUR)
!
        rlqmem = valarg*(1024*1024)
!
    else if (nomarg .eq. 'MEM_MUMP') then
!
! --------- CONSOMMATION MEMOIRE DU SOLVEUR MUMPS
!
        vmumps = valarg*(1024*1024)
!
    else if (nomarg .eq. 'MEM_PETS') then
!
! --------- CONSOMMATION MEMOIRE DU SOLVEUR PETSC
!
        vpetsc = valarg*(1024*1024)
!
    else if (nomarg .eq. 'MEM_INIT') then
!
! --------- CONSOMMATION MEMOIRE DU JDC
!
        vminit = valarg*(1024*1024)
!
    else if (nomarg .eq. 'MEM_JDC') then
!
! --------- CONSOMMATION MEMOIRE DU JDC
!
        vmjdc = valarg*(1024*1024)
!
    else
        iret = 1
    endif
!
end subroutine
