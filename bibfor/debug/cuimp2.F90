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

subroutine cuimp2(ifm, iliai, typope, typeou, resocu)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
    integer :: ifm
    character(len=24) :: resocu
    character(len=1) :: typope
    character(len=3) :: typeou
    integer :: iliai
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : ALGOCU
! ----------------------------------------------------------------------
!
! IMPRESSION DE L'ACTIVATION/DESACTIVATION DE LA LIAISON
!
! IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
! IN  ILIAI  : NUMERO DE LA LIAISON
! IN  DEFICU : SD DE DEFINITION (ISSUE D'AFFE_CHAR_MECA)
!
!
!
!
    character(len=8) :: noe, cmp
    character(len=20) :: chaiac
    character(len=24) :: nomnoe, nomcmp
    integer :: jnomno, jnomcm
!
! ----------------------------------------------------------------------
!
!
    nomnoe = resocu(1:14)//'.NOMNOE'
    nomcmp = resocu(1:14)//'.NOMCMP'
    call jeveuo(nomnoe, 'L', jnomno)
    call jeveuo(nomcmp, 'L', jnomcm)
!
    cmp = zk8(jnomcm-1+iliai)
    noe = zk8(jnomno-1+iliai)
!
    if (typope .eq. 'A') then
        chaiac = ' ACTIVEE     (ECART:'
    else if (typope.eq.'S') then
        chaiac = ' DESACTIVEE  (ECART:'
    endif
!
    if (typeou .eq. 'ALG') then
        write (ifm,1000) iliai,'(',noe,' - ',cmp,'): ', chaiac,')'
    else if (typeou.eq.'PIV') then
        chaiac = ' PIVOT NUL         ('
        write (ifm,1001) iliai,'(',noe,' - ',cmp,'): PIVOT NUL '
    else
        ASSERT(.false.)
    endif
!
!
!
    1000 format (' <LIA_UNIL> <> LIAISON ',i5,a1,a8,a3,a8,a3,a20,a1)
    1001 format (' <LIA_UNIL> <> LIAISON ',i5,a1,a8,a4,a8,a13)
!
!
!
end subroutine
