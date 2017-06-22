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

subroutine comptv(nbpt, fn, offset, t, nbchoc,&
                  tchmin, tchmax, tchoct, tchocm, nbrebo,&
                  trebot, trebom)
!        COMPTAGE DES CHOCS
!        ALGORITHME TEMPOREL A PAS VARIABLE
!
! IN  : NBPT   : NB DE POINTS DU SIGNAL
! IN  : FN     : TABLEAU DU SIGNAL
! IN  : T      : TABLEAU DU TEMPS
! IN  : OFFSET : VALEUR DU SEUIL DE DETECTION D UN CHOC
! OUT : NBCHOC : NB DE CHOC GLOBAUX ( CRITERE ELAPSE )
! OUT : NBREBO : NB DE REBONDS ( RETOUR AU SEUIL )
! OUT : TCHOCM : TEMPS DE CHOC GLOBAL MOYEN
! OUT : TREBOM : TEMPS DE REBOND MOYEN
! OUT : TCHOCT : TEMPS DE CHOC CUMULE
! ----------------------------------------------------------------------
!
    implicit none
    real(kind=8) :: fn(*), t(*)
!
!-----------------------------------------------------------------------
    integer :: i, ichoc, idebur, idebut, idech, ifin, ifinr
    integer :: irebo, nbchoc, nbpt, nbrebo
    real(kind=8) :: offset, tchmax, tchmin, tchoc, tchocm, tchoct, trebo
    real(kind=8) :: trebom, trebot, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    nbchoc = 0
    nbrebo = 0
    tchocm = zero
    tchoct = zero
    trebom = zero
    trebot = zero
    tchmax = zero
    tchmin = 1.0d20
    irebo = 0
    ichoc = 0
    idebut = 1
    idebur = 1
    ifin = 1
!
    do 10 i = 1, nbpt
!
        if (abs(fn(i)) .le. offset) then
!
            if (irebo .eq. 1) then
                ifinr = i
                trebo = t(ifinr) - t(idebur)
                trebom = trebom + trebo
                nbrebo = nbrebo + 1
            endif
!
            idech = 0
            if (abs(fn(i+1)) .gt. offset) idech =1
!
            if (idech .eq. 0 .and. ichoc .eq. 1) then
!
                ifin = i
                tchoc = t(ifin) - t(idebut)
                tchocm = tchocm + tchoc
!
                if (tchoc .gt. tchmax) tchmax = tchoc
!
                if (tchoc .lt. tchmin) tchmin = tchoc
!
                nbchoc = nbchoc + 1
                ichoc = 0
!
            endif
!
            irebo = 0
!
        else
!
            if (ichoc .eq. 0) idebut = i
!
            if (irebo .eq. 0) idebur = i
            irebo = 1
            ichoc = 1
!
        endif
!
10  continue
!
    tchoct = tchocm
    if (nbchoc .ne. 0) then
        tchocm=tchocm/nbchoc
    else
        tchocm = zero
    endif
!
    trebot = trebom
    if (nbrebo .ne. 0) then
        trebom = trebom / nbrebo
    else
        trebom = zero
    endif
!
end subroutine
