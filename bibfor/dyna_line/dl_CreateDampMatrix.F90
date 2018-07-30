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
!
subroutine dl_CreateDampMatrix(matr_rigi   , matr_mass  , l_cplx,&
                               nb_damp_read, l_damp_read,&
                               matr_damp)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/gettco.h"
#include "asterfort/utmess.h"
#include "asterfort/mtdefs.h"
#include "asterfort/mtdscr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/jexnum.h"
!
character(len=19), intent(in) :: matr_rigi, matr_mass
aster_logical, intent(in) :: l_cplx
integer, intent(in) :: nb_damp_read
real(kind=8), pointer :: l_damp_read(:)
character(len=19), intent(out)  :: matr_damp
!
! --------------------------------------------------------------------------------------------------
!
! Linear dynamic (DYNA_VIBRA)
!
! Create damping matrix from reduced modal damping
!
! --------------------------------------------------------------------------------------------------
!
! In  matr_rigi        : matrix of rigidity
! In  matr_mass        : matrix of mass
! In  l_cplx           : flag for complex rigidity matrix
! In  nb_damp_read     : number of damping coefficients
! In  l_damp_read      : list of damping coefficients
! Out matr_damp        : damping matrix
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: typobj
    integer, pointer :: v_matr_desc(:) => null()
    integer :: nb_equa, nb_mode, nbmod2, nb_damp, idiff, i_mode, i2
    integer :: ibloc, nbbloc, lgbloc, i_damp
    real(kind=8), pointer :: l_coef(:) => null()
    character(len=24) :: rigi_vale, mass_vale, damp_vale
    integer :: iatmat, iatmar, iatmam
    real(kind=8) :: acrit
!
! --------------------------------------------------------------------------------------------------
!
    nbbloc    = 1
    matr_damp = ' '
!
    call gettco(matr_rigi, typobj)
    if (typobj(1:14) .ne. 'MATR_ASSE_GENE') then
        call utmess('F', 'DYNALINE1_95')
    endif
    call jeveuo(matr_rigi(1:19)//'.&INT', 'L', vi = v_matr_desc)
    nb_equa = v_matr_desc(3)
    nb_mode = nb_equa
    nbmod2  = nb_equa*(nb_equa+1)/2
!
! - Create Damping matrix
!
    matr_damp = '&&COMDLH.AMORT_MATR'
    call mtdefs(matr_damp, matr_mass, 'V', 'R')
    call mtdscr(matr_damp)
    call jeveuo(matr_damp(1:19)//'.&INT', 'L', vi = v_matr_desc)
    lgbloc = v_matr_desc(15)
!
! - Create list of damping coefficient
!
    nb_damp = nb_mode
    call wkvect('&&COMDLH.AMORTI', 'V V R8', nb_damp, vr = l_coef)
!
! - Prepare list of damping coefficient
!
    if (nb_damp_read .gt. nb_damp) then
        call utmess('A', 'DYNALINE1_96', ni=3, vali=[nb_mode, nb_damp_read, nb_mode])
        l_coef(1:nb_damp) = l_damp_read(1:nb_damp)
    else if (nb_damp_read .lt. nb_mode) then
        l_coef(1:nb_damp) = l_damp_read(1:nb_damp)
        idiff = nb_mode - nb_damp_read
        call utmess('I', 'DYNALINE1_97', ni=3, vali=[idiff, nb_mode, idiff])
        do i_damp = nb_damp_read+1, nb_damp
            l_coef(i_damp) = l_damp_read(nb_damp_read)
        end do
    else if (nb_damp_read .eq. nb_mode) then
        l_coef(1:nb_damp) = l_damp_read(1:nb_damp)
    endif
!
    do ibloc = 1, nbbloc
! ----- Acces to values in rigidity matrix
        rigi_vale = matr_rigi(1:19)//'.VALM'
        call jeveuo(jexnum(rigi_vale, ibloc), 'L', iatmar)
! ----- Acces to values in mass matrix
        mass_vale = matr_mass(1:19)//'.VALM'
        call jeveuo(jexnum(mass_vale, ibloc), 'L', iatmam)
! ----- Acces to values in damping matrix
        damp_vale = matr_damp(1:19)//'.VALM'
        call jeveuo(jexnum(damp_vale, ibloc), 'E', iatmat)
        do i_mode = 1, nb_mode
            if (lgbloc .eq. nb_mode) then
                if (l_cplx) then
                    acrit = 2.d0*sqrt(abs(zc(iatmar-1+i_mode)*zr(iatmam-1+i_mode)))
                else
                    acrit = 2.d0*sqrt(abs(zr(iatmar-1+i_mode)*zr(iatmam-1+i_mode)))
                endif
                zr(iatmat-1+i_mode) = l_coef(i_mode)*acrit
            else if (lgbloc .eq. nbmod2) then
                i2 = i_mode*(i_mode+1)/2
                if (l_cplx) then
                    acrit = 2.d0*sqrt(abs(zc(iatmar-1+i2)* zr(iatmam-1+i2)) )
                else
                    acrit = 2.d0*sqrt(abs(zr(iatmar-1+i2)* zr(iatmam-1+i2)) )
                endif
                zr(iatmat-1+i2) = l_coef(i_mode)*acrit
            endif
        end do
    end do
!
end subroutine
