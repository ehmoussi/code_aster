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

subroutine xelrex(elrefp, nno, xref, ndime)
    implicit none
#include "asterf_types.h"
#include "asterfort/elraca.h"
    character(len=8) :: elrefp
    integer :: nno
    integer, optional :: ndime
    real(kind=8) :: xref(81)
!   BUT: INTERFACE VERS ELRACA : 
!         RETOURNE LES COORDONNEES DE REFERENCE DE 
!             L ELEMENT PARENT COMPLET
    integer :: nbfamx
    parameter    ( nbfamx=20)
    integer :: nnos, nbfpg, nbpg(nbfamx), ndim
    real(kind=8) :: vol
    character(len=8) :: fapg(nbfamx), elp
    aster_logical :: transfert
!=======================================================================
!
    transfert=.false.
    if ((elrefp .eq. 'H20')) then
        elp='H27'
        transfert=.true.
    else if ((elrefp .eq. 'P15')) then
        elp='P18'
        transfert=.true.
    else if ((elrefp .eq. 'QU8')) then
        elp='QU9'
        transfert=.true.       
    else
        elp=elrefp
    endif
    call elraca(elp, ndim, nno, nnos, nbfpg,&
                fapg, nbpg, xref, vol)
!   LE TRANSFERT VERS L ELMENT COMPLET EST AMBIGU
!     ON STOCKE LES COORDONNES DE REFERENCE DE L ELEMENT COMPLET
!     ON INTERPOLE SUR LE L ELEMENT PARENT => NNO (L ELMENT INCOMPLET)
    if (transfert) then
        if ((elrefp .eq. 'H20')) then
            nno=20
        else if ((elrefp .eq. 'P15')) then
            nno=15
        else if ((elrefp .eq. 'QU8')) then
            nno=8   
        endif
    endif
!
!   Cas particulier de la pyramide quadratique : le noeud au centre de
!   la base doit être ajouté à la main, car la pyramide quadratique à
!   14 noeuds n'existe pas en tant qu'élémént de référence dans Aster
    if (elrefp.eq.'P13') then
       xref(ndim*(14-1)+1)=0.
       xref(ndim*(14-1)+2)=0.
       xref(ndim*(14-1)+3)=0.
    endif
!
    if (present(ndime)) ndime=ndim
!
end
