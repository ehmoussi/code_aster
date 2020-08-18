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
subroutine ddr_comp(base, v_equa)
!
use Rom_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/r8gaem.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "blas/dgesv.h"
!
type(ROM_DS_Empi), intent(in) :: base
integer, pointer  :: v_equa(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Main process
!
! Application of DEIM method
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! In  v_equa           : list of equations selected by DEIM method (magic points)
!                        for each mode => the index of equation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv, iret
    integer :: iEqua, iMode, i_vect, i_matr, k_mode
    integer :: nbEqua, nbMode, nb_vect, jvPara, nb_motr
    integer :: equa_maxi, lval, ntp, ntm
    integer(kind=4) :: info
    integer(kind=4), pointer :: IPIV(:) => null()
    character(len=8)  :: resultName
    character(len=24) :: fieldName
    character(len=24) :: mode
    real(kind=8) :: vale_maxi, term
    real(kind=8), pointer :: v_mode(:) => null()
    real(kind=8), pointer :: v_resi(:) => null()
    real(kind=8), pointer :: v_base(:) => null()
    real(kind=8), pointer :: v_matr(:) => null()
    real(kind=8), pointer :: v_vect(:) => null()
    integer, pointer :: v_npl(:) => null()
    integer, pointer :: v_tuan(:) => null()
    integer, pointer :: v_list_loca(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM4_20')
    endif
!
! - Get parameters
!
    mode       = '&&CEIM_MODE'
    nbEqua     = base%mode%nbEqua
    nbMode     = base%nbMode
    resultName = base%resultName
    fieldName  = base%mode%fieldName
    ASSERT(base%mode%fieldSupp .eq. 'NOEU')
!
! - Prepare working objects
!
    AS_ALLOCATE(vr = v_resi, size = nbEqua)
    AS_ALLOCATE(vi = v_npl , size = nbMode)
    AS_ALLOCATE(vi = v_tuan, size = nbMode)
!
! - Get index of slice in reduced basis
!
    do iMode = 1, nbMode
        call rsadpa(resultName, 'L', 1, 'NUME_PLAN', iMode, 0, sjv=jvPara)
        v_npl(iMode) = zi(jvPara)
    enddo
!
    ntp = 1
    do iMode = 2, nbMode
        if (v_npl(iMode) .ne. v_npl(iMode-1)) then
            ntm = ntp
            ntp = 1
            v_tuan(iMode - ntm) = ntm
        else
            v_tuan(iMode) = 0
            ntp = ntp +1
        endif
    enddo
    v_tuan(nbMode+1-ntp) = ntp
!
! - Loop on modes
!
    do iMode = 1, nbMode
! - Check the mode (linear or 3D, how many slices?)
        if (v_tuan(iMode) .ne. 0) then
            nb_motr = v_tuan(iMode)
            AS_ALLOCATE(vr=v_base, size=nbEqua*nb_motr)
            AS_ALLOCATE(vi=v_list_loca, size=nb_motr)
! - First mode of slice
            k_mode = 1
            call rsexch(' ', resultName, fieldName, iMode+k_mode-1, mode, iret)
            ASSERT(iret .eq. 0)
            call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_mode)
            vale_maxi   = -r8gaem()
            equa_maxi   = 0
            do iEqua = 1, nbEqua
                v_base(iEqua) = v_mode(iEqua)
                if (abs(v_mode(iEqua)) .ge. vale_maxi) then
                    vale_maxi = abs(v_mode(iEqua))
                    equa_maxi = iEqua
                endif
            enddo
            v_equa(iMode) = equa_maxi
            v_list_loca(k_mode) = equa_maxi
! - Loop on mode of slice
            do k_mode = 2, nb_motr
                call rsexch(' ', resultName, fieldName, iMode+k_mode-1, mode, iret)
                ASSERT(iret .eq. 0)
                call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_mode)
                nb_vect = k_mode-1
                AS_ALLOCATE(vr=v_vect, size=nb_vect)
                AS_ALLOCATE(vr=v_matr, size=nb_vect*nb_vect)
                AS_ALLOCATE(vi4=IPIV, size=nb_vect)
                do i_vect = 1, nb_vect
                    v_vect(i_vect) = v_mode(v_list_loca(i_vect))
                    do i_matr = 1, nb_vect
                        v_matr(i_vect+nb_vect*(i_matr-1)) =&
                            v_base(v_list_loca(i_vect)+nbEqua*(i_matr-1))
                    enddo
                enddo
                lval = MAX(1,nb_vect)
                call dgesv(nb_vect,1,v_matr,lval,IPIV,v_vect,lval,info)
                if (info .ne. 0) then
                    call utmess('F', 'ROM4_7')
                endif
                do iEqua = 1, nbEqua
                    term = 0
                    do i_vect = 1, nb_vect
                        term = term+v_base(iEqua+nbEqua*(i_vect-1))*v_vect(i_vect)
                    enddo
                    v_resi(iEqua)=v_mode(iEqua)-term
                enddo
                vale_maxi   = -r8gaem()
                equa_maxi   = 0
                do iEqua = 1, nbEqua
                    v_base(iEqua+nbEqua*(k_mode-1)) = v_mode(iEqua)
                    if (abs(v_resi(iEqua)) .ge. vale_maxi) then
                        vale_maxi = abs(v_resi(iEqua))
                        equa_maxi = iEqua
                    endif
                enddo
                v_equa(iMode+k_mode-1) = equa_maxi
                v_list_loca(k_mode) = equa_maxi
                AS_DEALLOCATE(vi4=IPIV)
                AS_DEALLOCATE(vr=v_vect)
                AS_DEALLOCATE(vr=v_matr)
            enddo
            AS_DEALLOCATE(vr=v_base)
            AS_DEALLOCATE(vi=v_list_loca)
        endif
    enddo
    AS_DEALLOCATE(vr=v_resi)
    AS_DEALLOCATE(vi=v_npl)
    AS_DEALLOCATE(vi=v_tuan)
!
end subroutine
