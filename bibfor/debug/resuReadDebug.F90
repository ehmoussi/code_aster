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
subroutine resuReadDebug(resultName,&
                         fieldNb   , fieldList, fieldStoreNb,&
                         storePara , storeEpsi, storeCrit)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/utmess.h"
#include "asterfort/rsorac.h"
#include "asterfort/rsadpa.h"
!
character(len=8), intent(in) :: resultName
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
integer, intent(in) :: fieldStoreNb(100)
character(len=4), intent(in) :: storePara
real(kind=8), intent(in) :: storeEpsi
character(len=8), intent(in) :: storeCrit
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Debug
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  fieldNb          : number of fields to read
! In  fieldList        : list of fields to read
! In  fieldStoreNb     : effective number of fields has been saved
! In  storePara        : name of paremeter to access results (INST or FREQ)
! In  storeEpsi        : tolerance to find time/freq (real)
! In  storeCrit        : type of tolerance to find time/freq (real)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iField, ibid, nbtrou, iStore, jvPara, storeNb
    real(kind=8) :: rbid
    character(len=8) :: k8bid
    character(len=16) :: fieldType
    complex(kind=8) :: cbid
    integer, pointer :: storeNume(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'RESULT2_1')
    do iField = 1, fieldNb
        fieldType = fieldList(iField)
        storeNb   = fieldStoreNb(iField)
        call utmess('I', 'RESULT2_2', sk = fieldType)
        AS_ALLOCATE(vi = storeNume, size = storeNb)
        call rsorac(resultName, 'TOUT_ORDRE', ibid, rbid, k8bid,&
                    cbid      , storeEpsi, storeCrit, storeNume, storeNb,&
                    nbtrou)
        do iStore = 1, storeNb
            call rsadpa(resultName, 'L', 1, storePara, storeNume(iStore), 0, sjv=jvPara)
            call utmess('I', 'RESULT2_3', si = storeNume(iStore),&
                                          sk = storePara,&
                                          sr = zr(jvPara))
        end do
        AS_DEALLOCATE(vi = storeNume)
    end do
!
end subroutine
