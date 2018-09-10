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

subroutine gcfonc(ichar, iord, cartei, lfchar, lfmult,&
                  newfct, lformu)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/codent.h"
#include "asterfort/gverfo.h"
#include "asterfort/utmess.h"
!
!
    aster_logical, intent(in) :: lfmult
    aster_logical, intent(in) :: lfchar
    integer, intent(in) :: ichar
    integer, intent(in) :: iord
    character(len=8), intent(out) :: newfct
    character(len=19), intent(in) :: cartei
    aster_logical, intent(out) :: lformu
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE CALC_G
!
! PREPARE LE NOM DE LA NOUVELLE FONCTION POUR LES CHARGEMENTS
!
! --------------------------------------------------------------------------------------------------
!
! IN  LFCHAR : .TRUE.  SI LE CHARGEMENT EST 'FONCTION' (AFFE_CHAR_MECA_F)
! IN  LFMULT : .TRUE.  S'IL Y A UNE FONCTION MULTIPLICATRICE
! IN  ICHAR  : INDICE DU CHARGEMENT
! IN  IORD   : NUMERO D'ORDRE CORRESPONDANT A TIME
! IN  CARTEI : NOM DU CHARGEMENT
! OUT NEWFCT : FONCTION MULTIPLICATRICE MODIFIEE DANS LA CARTE DE SORTIE
!              PRODUIT DE LA FONC_MULT ET DE LA DEPENDANCE EVENTUELLE
!              VENUE D'AFFE_CHAR_MECA_F
! OUT LFORMU : .TRUE.  SI LE CHARGEMENT 'FONCTION' UTILISE UNE FORMULE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=8) :: nomchf
!
! --------------------------------------------------------------------------------------------------
!
    lformu = .false.
    nomchf = ' '
!
! - SI FONCTION MULT + CHARGEMENT *_F -> ON DOIT COMBINER
!
    if (lfmult) then
        if (lfchar) then
            nomchf = '&FM00000'
            if ((ichar.gt.9) .or. (iord.gt.99)) then
                call utmess('F', 'RUPTURE2_1')
            endif
            call codent(ichar*10+1, 'D0', nomchf(6:7))
            call codent(iord, 'D0', nomchf(4:5))
        endif
    endif
    newfct = nomchf
!
! - VERIFIE SI LE CHARGEMENT FONCTION EST DE TYPE 'FORMULE'
!
    if (lfchar) then
        call gverfo(cartei, iret)
        if (iret .eq. 1) lformu = .true.
    endif
!
end subroutine
