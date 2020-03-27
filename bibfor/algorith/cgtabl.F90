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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine cgtabl(table_container, nb_obje, obje_name, obje_sdname, nb_cham_theta)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbacce.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in)  :: table_container
integer, intent(in)           :: nb_obje, nb_cham_theta
character(len=16), intent(in) :: obje_name(nb_obje)
character(len=24), intent(in) :: obje_sdname(nb_obje)
!
!
! --------------------------------------------------------------------------------------------------
!
! Command CALC_G_OPER
!
! Management of result (TABLE_CONTAINER)
!
! --------------------------------------------------------------------------------------------------
!
! In  table_container  : name of created table container
! In  nb_obje          : number of new objects to add
! In  obje_name        : name of new objects to add
! In  obje_sdname      : datastructure name of new objects to add
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbpara = 4
    character(len=19), parameter :: nompar(nbpara) = (/&
        'NOM_OBJET ', 'TYPE_OBJET', 'NOM_SD    ', 'NUME_ORDRE'/)
    character(len=19), parameter :: typpar(nbpara) = (/&
        'K16', 'K16', 'K24', 'I  '/)
!
    integer, parameter :: l_nb_obje = 3
    character(len=16), parameter :: l_obje_name(l_nb_obje) = (/&
        'TABLE_G         ', 'CHAM_THETA      ', 'NB_CHAM_THETA   '/)
    character(len=16), parameter :: l_obje_type(l_nb_obje) = (/&
        'TABLE           ', 'CHAM_NO         ', 'ENTIER          '/)
!
    integer :: i_l_obj, i_obj, nume_store, nume_store_theta
    character(len=24) :: vk(3)
    character(len=16) :: obje_type
    aster_logical, parameter :: debug= ASTER_FALSE
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Create new table_container
!
    call detrsd('TABLE_CONTAINER', table_container)
    call tbcrsd(table_container, 'G')
    call tbajpa(table_container, nbpara, nompar, typpar)
!
! - Loop on objects to add new one
!
    if(debug) then
        print*, "Create table_container in CALC_G"
        print*, "Number of object: ", nb_obje
    end if
!
    nume_store_theta = 0
    do i_obj = 1, nb_obje
!
! ----- Find the type of object
!
        obje_type = ' '
        do i_l_obj = 1, l_nb_obje
            if (l_obje_name(i_l_obj) .eq. obje_name(i_obj)) then
                obje_type = l_obje_type(i_l_obj)
                exit
            endif
        end do
        ASSERT(obje_type .ne. ' ')
!
! ----- Add object (new line)
!
        if(debug) then
            print*, "OBJET NAME", i_obj, " : ", obje_name(i_obj)
            print*, "OBJET TYPE", i_obj, " : ", obje_type
            print*, "SD NAME   ", i_obj, " : ", obje_sdname(i_obj)

        end if
!
        vk(1) = obje_name(i_obj)
        vk(2) = obje_type
        vk(3) = obje_sdname(i_obj)
!
        if(obje_name(i_obj)== "CHAM_THETA") then
            nume_store_theta = nume_store_theta + 1
            nume_store = nume_store_theta
        elseif(obje_name(i_obj) == "NB_CHAM_THETA") then
            nume_store = nb_cham_theta
        else
            nume_store = 1
        end if
!
        call tbajli(table_container, nbpara, nompar, &
                    [nume_store], [0.d0], [cmplx(0.d0, 0.d0)], vk, 0)
    end do
!
    call jedema()
!
end subroutine
