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

subroutine utlcal(typque, algo, valr)
    implicit      none
!
! person_in_charge: samuel.geniaut at edf.fr
!
#include "asterfort/assert.h"
    character(len=8) :: typque
    character(len=16) :: algo
    real(kind=8) :: valr
!
! ----------------------------------------------------------------------
!
!
! ROUTINE UTILITAIRE POUR LES LOIS DE COMPORTEMENTS
!   FAIT LE LIEN ENTRE LE NOM DE L'ALGORIHTME D'INTEGRATION LOCALE
!   ET SON N° (VALEUR REELLE)
!
! ----------------------------------------------------------------------
!
! IN  TYPQUE    : SI 'NOM_VALE' : TRADUCTION NOM -> VALEUR REELE
!                 SI 'VALE_NOM' : TRADUCTION VALEUR REELE -> NOM
! IN/OUT VALR   : VALEUR REELE
! IN/OUT VALR   : NOM DE L'ALGORITHME
!
!
    ASSERT(typque.eq.'NOM_VALE'.or. typque.eq.'VALE_NOM')
!
    if (typque .eq. 'NOM_VALE') then
!
!
        if (algo .eq. 'ANALYTIQUE') then
            valr = 0.d0
        else if (algo.eq.'SECANTE') then
            valr = 1.d0
        else if (algo.eq.'DEKKER') then
            valr = 2.d0
        else if (algo.eq.'NEWTON_1D') then
            valr = 3.d0
        else if (algo.eq.'NEWTON') then
            valr = 4.d0
        else if (algo.eq.'NEWTON_RELI') then
            valr = 5.d0
        else if (algo.eq.'RUNGE_KUTTA') then
            valr = 6.d0
        else if (algo.eq.'SPECIFIQUE') then
            valr = 7.d0
        else if (algo.eq.'SANS_OBJET') then
            valr = 8.d0
        else if (algo.eq.'BRENT') then
            valr = 9.d0
        else if (algo.eq.'NEWTON_PERT') then
            valr =10.d0
        else
            ASSERT(.false.)
        endif
!
!
    else if (typque.eq.'VALE_NOM') then
!
!
        if (valr .eq. 0.d0) then
            algo = 'ANALYTIQUE'
        else if (valr.eq.1.d0) then
            algo = 'SECANTE'
        else if (valr.eq.2.d0) then
            algo = 'DEKKER'
        else if (valr.eq.3.d0) then
            algo = 'NEWTON_1D'
        else if (valr.eq.4.d0) then
            algo = 'NEWTON'
        else if (valr.eq.5.d0) then
            algo = 'NEWTON_RELI'
        else if (valr.eq.6.d0) then
            algo = 'RUNGE_KUTTA'
        else if (valr.eq.7.d0) then
            algo = 'SPECIFIQUE'
        else if (valr.eq.8.d0) then
            algo = 'SANS_OBJET'
        else if (valr.eq.9.d0) then
            algo = 'BRENT'
        else if (valr.eq.10.d0) then
            algo = 'NEWTON_PERT'
        else
            ASSERT(.false.)
        endif
!
    endif
!
end subroutine
