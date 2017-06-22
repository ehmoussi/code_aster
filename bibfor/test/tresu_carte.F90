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

subroutine tresu_carte(cham19, nomail, nocmp, tbtxt, refi,&
                       refr, refc, typres, epsi, crit,&
                       llab, ignore, compare)
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/utchca.h"
#include "asterfort/tresu_print_all.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: cham19
    character(len=*), intent(in) :: nomail
    character(len=*), intent(in) :: nocmp
    character(len=16), intent(in) :: tbtxt(2)
    integer, intent(in) :: refi
    real(kind=8), intent(in) :: refr
    complex(kind=8), intent(in) :: refc
    character(len=*), intent(in) :: typres
    real(kind=8), intent(in) :: epsi
    character(len=*), intent(in) :: crit
    aster_logical, intent(in) :: llab
    aster_logical, intent(in), optional :: ignore
    real(kind=8), intent(in), optional :: compare
! person_in_charge: jacques.pellet at edf.fr
! IN  : CHAM19 : NOM DE LA CARTE DONT ON DESIRE VERIFIER 1 COMPOSANTE
! IN  : NOMAIL : NOM DE LA MAILLE A TESTER
! IN  : NOCMP  : NOM DU DDL A TESTER
! IN  : TBTXT  : (1)=REFERENCE, (2)=LEGENDE
! IN  : REFR   : VALEUR REELLE ATTENDUE
! IN  : REFI   : VALEUR REELLE ATTENDUE
! IN  : REFC   : VALEUR COMPLEXE ATTENDUE
! IN  : CRIT   : 'RELATIF' OU 'ABSOLU'(PRECISION RELATIVE OU ABSOLUE).
! IN  : EPSI   : PRECISION ESPEREE
! IN  : LLAB   : FLAG D IMPRESSION DES LABELS
! OUT : IMPRESSION SUR LISTING
! ----------------------------------------------------------------------
    integer :: vali, ier
    real(kind=8) :: valr
    complex(kind=8) :: valc
    character(len=8) :: nomma
    character(len=4) :: tych
    aster_logical :: skip
    real(kind=8) :: ordgrd
!     ------------------------------------------------------------------
    skip = .false.
    if (present(ignore)) then
        skip = ignore
    endif
!
    ordgrd = 1.d0
    if (present(compare)) then
        ordgrd = compare
    endif
!
    call dismoi('TYPE_CHAMP', cham19, 'CHAMP', repk=tych)
    if (tych .ne. 'CART') then
        call utmess('F', 'CALCULEL3_90', sk=cham19)
    endif
!
    call dismoi('NOM_MAILLA', cham19, 'CARTE', repk=nomma)
!
    call utchca(cham19, nomma, nomail, nocmp, typres,&
                valr, vali, valc, ier)
    ASSERT(ier .eq. 0)

    call tresu_print_all(tbtxt(1), tbtxt(2), llab, typres, 1,&
                         crit, epsi, 'NON', [refr], valr,&
                         [refi], vali, [refc], valc, ignore=skip,&
                         compare=ordgrd)
!
end subroutine
