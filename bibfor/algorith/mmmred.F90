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

subroutine mmmred(ndimg, lctfc, champ, champr, ndd1)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mmfield_prep.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: ndimg
    character(len=19) :: champ, champr
    aster_logical :: lctfc
    integer :: ndd1
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - POST-TRAITEMENT)
!
! REDUCTION DU CHAMP SUR LES DDL
!
! ----------------------------------------------------------------------
!
!
! IN  NDIMG  : DIMENSION DE L'ESPACE
! IN  LCTFC  : .TRUE. SI FROTTEMENT
! IN  CHAMP  : CHAM_NO A REDUIRE
! OUT CHAMPR : CHAM_NO_S REDUIT DE L'INCREMENT DE DEPLACEMENT CUMULE
! OUT NDD1   : NOMBRE DE DDL/NOEUD
!
!
!
!
    if (ndimg .eq. 3) then
        if (lctfc) then
            ndd1 = 6
            call mmfield_prep(champ, champr,&
                              l_sort_ = .true._1, nb_cmp_ = ndd1,&
                              list_cmp_ = ['DX      ','DY      ','DZ      ',&
                                           'LAGS_C  ','LAGS_F1 ','LAGS_F2 '])
        else
            ndd1 = 4
            call mmfield_prep(champ, champr,&
                              l_sort_ = .true._1, nb_cmp_ = ndd1,&
                              list_cmp_ = ['DX      ','DY      ','DZ      ',&
                                           'LAGS_C  '])
        endif
    else if (ndimg.eq.2) then
        if (lctfc) then
            ndd1 = 4
            call mmfield_prep(champ, champr,&
                              l_sort_ = .true._1, nb_cmp_ = ndd1,&
                              list_cmp_ = ['DX      ','DY      ',&
                                           'LAGS_C  ','LAGS_F1 '])
        else
            ndd1 = 3
            call mmfield_prep(champ, champr,&
                              l_sort_ = .true._1, nb_cmp_ = ndd1,&
                              list_cmp_ = ['DX      ','DY      ',&
                                           'LAGS_C  '])
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
