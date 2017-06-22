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

subroutine rvinfa(ifm, mcf, iocc, qnt, opt,&
                  opr, rep)
    implicit none
#include "asterfort/getvr8.h"
    integer :: ifm
    character(len=*) :: mcf, qnt, opt, opr, rep
!     AFFICHAGE DES INFO SUR LA QUANTITE TRAITE
!     ------------------------------------------------------------------
! IN  REP    : K : REPERE
! IN  OPT    : K : OPTION
! IN  QNT    : K : QUANTITE
! IN  OPR    : K : OPERATION
!     ------------------------------------------------------------------
!
    character(len=80) :: mess
    integer :: iocc, pt, n1
    real(kind=8) :: poin(3)
!
    mess = ' '
    pt = 1
    if (opr(1:1) .eq. 'E') then
        mess(pt:pt+10) = 'EXTRACTION'
        pt = pt + 12
    else if (opr(1:1) .eq. 'S') then
        mess(pt:pt+17) = 'RESULTANTE_MOMENT'
        pt = pt + 19
    else if (opr(1:7) .eq. 'MOYENNE') then
        mess(pt:pt+7) = 'MOYENNE'
        pt = pt + 9
    else if (opr(1:4) .eq. 'RCCM') then
        mess(pt:pt+11) = 'RCC-M B3200'
        pt = pt + 13
    else
    endif
    if (qnt(1:7) .eq. 'TRACE_N') then
        mess(pt:pt+13) = 'TRACE_NORMALE'
        pt = pt + 15
    else if (qnt(1:7) .eq. 'TRACE_D') then
        mess(pt:pt+19) = 'TRACE_DIRECTIONELLE'
        pt = pt + 21
    else if (qnt(1:7) .eq. 'INVARIA') then
        mess(pt:pt+10) = 'INVARIANTS'
        pt = pt + 12
    else if (qnt(1:7) .eq. 'ELEM_PR') then
        mess(pt:pt+19) = 'ELEMENTS_PRINCIPAUX'
        pt = pt + 21
    else
    endif
!
    if ((opt(1:4) .eq. 'SIGM') .or. (opt(1:4) .eq. 'SIEF')) then
        mess(pt:80) = 'TENSEUR CONTRAINTE'
    else if (opt(1:4) .eq. 'EPSI') then
        mess(pt:80) = 'TENSEUR DEFORMATION'
    else if (opt(1:4) .eq. 'EFGE') then
        mess(pt:80) = 'TENSEURS MOMENT_FLECHISSANT EFFORT_GENERALISE'
    else if (opt(1:4) .eq. 'DEPL') then
        mess(pt:80) = 'DEPLACEMENTS'
    else if (opt(1:4) .eq. 'TEMP') then
        mess(pt:80) = 'TEMPERATURE'
    else if (opt(1:4) .eq. 'FORC') then
        mess(pt:80) = 'FORCE'
    else if (opt(1:4) .eq. 'FLUX') then
        mess(pt:80) = 'FLUX'
    else
    endif
!
    write(ifm,*)' '
    write(ifm,*)mess
!
    if (opr(1:1) .eq. 'S' .and. mcf(1:6) .eq. 'ACTION') then
        call getvr8(mcf, 'POINT', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .eq. -2) then
            call getvr8(mcf, 'POINT', iocc=iocc, nbval=2, vect=poin,&
                        nbret=n1)
            write(ifm,1000) poin(1) , poin(2)
        else if (n1 .eq. -3) then
            call getvr8(mcf, 'POINT', iocc=iocc, nbval=3, vect=poin,&
                        nbret=n1)
            write(ifm,1010) poin(1) , poin(2) , poin(3)
        endif
    endif
!
    if (rep(1:1) .eq. 'G') then
        write(ifm,*)'REPERE GLOBAL'
    else if (rep(1:1) .eq. 'L') then
        write(ifm,*)'REPERE LOCAL'
    else if (rep(1:1) .eq. 'P') then
        write(ifm,*)'REPERE POLAIRE'
    else
    endif
    write(ifm,*)' '
!
    1000 format ( ' MOMENT PAR RAPPORT AU POINT : ',1p,e12.5,1x,e12.5)
    1010 format ( ' MOMENT PAR RAPPORT AU POINT : ',1p,e12.5,1x,e12.5,&
     &                                           1x,e12.5)
!
end subroutine
