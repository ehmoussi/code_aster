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
!
subroutine resuReadCreateREFD(resultName, resultType, matrRigi, matrMass)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/idensd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
#include "asterfort/refdaj.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: resultName
character(len=16), intent(in) :: resultType
character(len=8), intent(in) :: matrRigi, matrMass
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Create .REFD object and save matrices 
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! In  matrRigi         : matrice of rigidity
! In  matrMass         : matrice of mass
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=14) :: numeRigi, numeMass
    character(len=19) :: profRigi, profMass
    character(len=24) :: matric(3)
!
! --------------------------------------------------------------------------------------------------
!
    if (resultType .eq. 'DYNA_TRANS' .or.&
        resultType .eq. 'DYNA_HARMO' .or.&
        resultType(1:9) .eq. 'MODE_MECA') then
        call jeexin(resultName//'           .REFD', iret)
        if (iret .eq. 0) then
            call refdaj(' ', resultName, -1, ' ', 'INIT', ' ', iret)
        endif
    endif
!
    if (resultType(1:9) .eq. 'MODE_MECA') then
        numeRigi = ' '
        if (matrRigi .ne. ' ') then
            call utmess('I', 'RESULT2_14', sk=matrRigi)
            call dismoi('NOM_NUME_DDL', matrRigi, 'MATR_ASSE', repk=numeRigi)
            if (matrMass .ne. ' ') then
                call dismoi('NOM_NUME_DDL', matrMass, 'MATR_ASSE', repk=numeMass)
                if (numeMass .ne. numeRigi) then
                    profRigi = (numeRigi//'.NUME')
                    profMass = (numeMass//'.NUME')
                    if (.not.idensd('PROF_CHNO', profRigi, profMass)) then
                        call utmess('F', 'RESULT2_15')
                    endif
                endif
            endif
        endif
        matric(1) = matrRigi
        matric(2) = matrMass
        matric(3) = ' '
        call refdaj('F', resultName, -1, numeRigi, 'DYNAMIQUE', matric, iret)
    endif
!
end subroutine
