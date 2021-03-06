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

subroutine carota(load, mesh, vale_type)
!
    implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/r8miem.h"
#include "asterfort/assert.h"
#include "asterfort/char_crea_cart.h"
#include "asterfort/char_read_val.h"
#include "asterfort/char_read_vect.h"
#include "asterfort/getelem.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/normev.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: load
    character(len=8), intent(in) :: mesh
    character(len=4), intent(in) :: vale_type
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Keyword = 'ROTATION'
!
! --------------------------------------------------------------------------------------------------
!
!
! In  mesh      : name of mesh
! In  load      : name of load
! In  vale_type : affected value type (real, complex or function)
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8) :: c16dummy
    character(len=8) :: k8dummy
    character(len=16) :: k16dummy
    real(kind=8) :: rota_speed, rota_axis(3), rota_cent(3)
    real(kind=8) :: norme
    integer :: iocc, nrota, nb_cmp, val_nb
    character(len=16) :: keywordfact
    character(len=24) :: list_elem
    integer :: j_elem
    integer :: nb_elem
    character(len=19) :: carte
    integer :: nb_carte
    real(kind=8), pointer :: valv(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    keywordfact = 'ROTATION'
    call getfac(keywordfact, nrota)
    if (nrota .eq. 0) goto 99
!
    ASSERT(nrota.eq.1)
!
! - Initializations
!
    ASSERT(vale_type.eq.'REEL')
    list_elem = '&&CAROTA.LISTELEM'
!
! - Creation and initialization to zero of <CARTE>
!
    call char_crea_cart('MECANIQUE', keywordfact, load, mesh, vale_type,&
                        nb_carte, carte)
    ASSERT(nb_carte.eq.1)
!
! - Loop on keywords
!
    do iocc = 1, nrota
!
! ----- Elements
!
        call getelem(mesh, keywordfact, iocc, 'F', list_elem, &
                     nb_elem)
        call jeveuo(list_elem, 'L', j_elem)
!
! ----- Get speed
!
        call char_read_val(keywordfact, iocc, 'VITESSE', vale_type, val_nb,&
                           rota_speed, k8dummy, c16dummy, k16dummy)
        ASSERT(val_nb.eq.1)
!
! ----- Get axis
!
        call char_read_vect(keywordfact, iocc, 'AXE', rota_axis)
        call normev(rota_axis, norme)
        if (norme .le. r8miem()) then
            call utmess('F', 'CHARGES2_53')
        endif
!
! ----- Get center
!
        call char_read_vect(keywordfact, iocc, 'CENTRE', rota_cent)
!
! ----- Affectation of values in <CARTE>
!
        call jeveuo(carte//'.VALV', 'E', vr=valv)
        nb_cmp = 7
        valv(1) = rota_speed
        valv(2) = rota_axis(1)
        valv(3) = rota_axis(2)
        valv(4) = rota_axis(3)
        valv(5) = rota_cent(1)
        valv(6) = rota_cent(2)
        valv(7) = rota_cent(3)
        call nocart(carte, 3, nb_cmp, mode='NUM', nma=nb_elem,&
                    limanu=zi(j_elem))
!
        call jedetr(list_elem)
    end do
!
99  continue
    call jedema()
end subroutine
