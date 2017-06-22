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

subroutine uttcpg(action, typimp)
    implicit none
#include "jeveux.h"
#include "asterfort/uttcpi.h"
#include "asterfort/uttcpl.h"
#include "asterfort/uttcpu.h"
    character(len=*) :: action, typimp
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!  BUT : GERER LES MESURES DE TEMPS "GENERALES" : CELLES DONT LA LISTE
!        EST DONNEE DANS UTTCPL ET QUI SONT PILOTEES GRACE AU MOT CLE
!        DEBUT/MESURE_TEMPS/NIVE_DETAIL
!
!  ACTION = 'INIT' : ON INITIALISE LES DIFFERENTES MESURES
!  ACTION = 'IMPR' : ON IMPRIME LES DIFFERENTES MESURES
!  TYPIMP = 'CUMU' : ON IMPRIME LE "CUMUL" DE LA MESURE
!  TYPIMP = 'INCR' : ON IMPRIME L'INCREMENT DE LA MESURE
! ----------------------------------------------------------------------
!
!     -- COMMONS POUR MESURE DE TEMPS :
!        MTPNIV : NIVEAU D'IMPRESSION DES MESURES DE TEMPS DEMANDE
!                 PAR L'UTILISATEUR
!        MTPSTA : IMPRESSION DES STATISTIQUES OU NON EN PARALLELE
    integer :: mtpniv, mtpsta, indmax
    parameter (indmax=5)
    character(len=80) :: snolon(indmax)
    real(kind=8) :: valmes(indmax*7), valmei(indmax*7)
    common /mestp1/ mtpniv,mtpsta
    common /mestp2/ snolon
    common /mestp3/ valmes,valmei
!
    integer :: ndim, nbmesu
    parameter (ndim=30)
    integer :: ifm, k
    character(len=1) :: prpal(ndim)
    character(len=24) :: nomc(ndim)
    character(len=80) :: noml(ndim)
!----------------------------------------------------------------------
!
    call uttcpl(ndim, nbmesu, nomc, noml, prpal)
!
    if (action .eq. 'INIT') then
        do k = 1, nbmesu
            call uttcpu(nomc(k), 'INIT', noml(k))
        end do
!
    else if (action.eq.'IMPR') then
        ifm=6
!
        if (mtpniv .eq. 1) then
            do k = 1, nbmesu
                if (prpal(k) .eq. 'S') cycle
                if (typimp .eq. 'INCR') cycle
                call uttcpi(nomc(k), ifm, typimp)
            end do
!
        else if (mtpniv.eq.2) then
            do k = 1, nbmesu
                if (typimp .eq. 'INCR') cycle
                call uttcpi(nomc(k), ifm, typimp)
            end do
!
        else if (mtpniv.eq.3) then
            do k = 1, nbmesu
                call uttcpi(nomc(k), ifm, typimp)
            end do
!
        endif
!
    endif
!
end subroutine
