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

subroutine ccvrch(resuin, numor0, lforc_noda)
    implicit none
!     --- ARGUMENTS ---
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterfort/dismoi.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: resuin
    integer :: numor0
    aster_logical :: lforc_noda
! person_in_charge: nicolas.sellenet at edf.fr
!
    integer :: nchalu, jpara
!
    character(len=8) :: k8b
    character(len=24) :: excisd, modele
!
    nchalu=0
!
    if (getexm('EXCIT','CHARGE') .eq. 1) call getfac('EXCIT', nchalu)
!
    call rsadpa(resuin, 'L', 1, 'EXCIT', numor0,&
                0, sjv=jpara, styp=k8b)
    excisd=zk24(jpara)
!
    if (excisd .eq. ' ') then
        if (nchalu .eq. 0) then
!
            call rsadpa(resuin, 'L', 1, 'MODELE', numor0,&
                        0, sjv=jpara, styp=k8b)
            modele=zk8(jpara)
            ! Si on n'a pas de modele dans la sd_resu, ca veut sans doute dire
            ! qu'on est en presence d'une sd issue de la dynamique
            ! Dans ce cas-la l'emission de l'alarme CALCCHAMP_6 a tout son sens
            if (modele.ne.' ') then
                call dismoi('EXI_POUX', modele, 'MODELE', repk=k8b)
            else
                k8b = 'OUI'
            endif
!
            if (k8b.eq.'OUI' .or. lforc_noda) then
                call utmess('A', 'CALCCHAMP_6', sk=resuin)
            endif
        else
            call utmess('A', 'CALCCHAMP_5', sk=resuin)
        endif
    endif
!
end subroutine
