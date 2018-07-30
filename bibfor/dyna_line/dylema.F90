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
subroutine dylema(matr_rigi   , matr_mass, matr_damp, matr_impe,&
                  l_damp_modal, l_damp   , l_impe   ,&
                  nb_matr     , matr_list, coef_type, coef_vale,&
                  matr_resu   , numddl   , nb_equa)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/gettco.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtdscr.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/dl_CreateDampMatrix.h"
#include "asterfort/dl_MatrixPrepare.h"
!
character(len=19), intent(out) :: matr_mass, matr_rigi, matr_damp, matr_impe
aster_logical, intent(out) :: l_damp_modal, l_damp, l_impe
integer, intent(out) :: nb_matr
character(len=24), intent(out) :: matr_list(*)
character(len=1), intent(out) :: coef_type(*)
real(kind=8), intent(out) :: coef_vale(*)
character(len=19), intent(out) :: matr_resu
character(len=14), intent(out) :: numddl
integer, intent(out) :: nb_equa
!
! --------------------------------------------------------------------------------------------------
!
! DYNA_VIBRA
!
! Read matrixes
!
! --------------------------------------------------------------------------------------------------
!
! Out matr_rigi        : matrix of rigidity
! Out matr_mass        : matrix of mass
! Out matr_damp        : matrix of damping
! Out matr_impe        : matrix of impedance
! Out l_damp           : flag if damping
! Out l_damp_modal     : flag if modal damping
! Out l_impe           : flag for impedance
! Out nb_matr          : number of matrixes in linear combination
! Out matr_list        : list of matrixes in linear combination
! Out coef_type        : type of coefficient (R ou C) for each matrix in linear combination
! Out coef_vale        : value of coefficient for each matrix in linear combination
! Out matr_resu        : resultant matrix of linear combination
! Out numddl           : object for numbering matrixes
! Out nb_equa          : total number of equations
!
! --------------------------------------------------------------------------------------------------
!
    integer :: n1, n2, n
    integer :: nb_damp_read
    character(len=1) :: ktyp, resu_type
    character(len=8) :: list_damp, matr_res8
    character(len=16) :: typobj
    character(len=14) :: numdl1, numdl2, numdl3
    aster_logical :: l_cplx, l_harm
    real(kind=8), pointer :: l_damp_read(:) => null()
    real(kind=8), pointer :: v_list(:) => null()
    integer, pointer :: v_matr_desc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    resu_type    = 'C'
    nb_equa      = 0
    nb_matr      = 0
    matr_rigi    = ' '
    matr_mass    = ' '
    matr_damp    = ' '
    matr_impe    = ' '
    matr_resu    = ' '
    numddl       = ' '
    l_cplx       = ASTER_FALSE
    l_damp_modal = ASTER_FALSE
    l_damp       = ASTER_FALSE
    l_impe       = ASTER_FALSE
    l_harm       = ASTER_TRUE
!
! - Get matrixes
!
    call getvid(' ', 'MATR_MASS', scal=matr_mass, nbret=n1)
    call getvid(' ', 'MATR_RIGI', scal=matr_rigi, nbret=n1)
    call getvid(' ', 'MATR_AMOR', scal=matr_damp, nbret=n1)
    l_damp = n1 .ne. 0
    call getvid(' ', 'MATR_IMPE_PHI', scal=matr_impe, nbret=n1)
    l_impe = n1 .ne. 0
!
! - Add rigidity matrix
!
    call mtdscr(matr_rigi)
    call jelira(matr_rigi//'.VALM', 'TYPE', cval=ktyp)
    if (ktyp .eq. 'C') then
        l_cplx = ASTER_TRUE
    endif
    call jeveuo(matr_rigi(1:19)//'.&INT', 'L', vi = v_matr_desc)
    nb_equa = v_matr_desc(3)
!
! - Add mass matrix
!
    call mtdscr(matr_mass)
!
! - Add damping matrix (given matrix)
!
    if (l_damp) then
        call mtdscr(matr_damp)
    endif
!
! --- TEST: LES MATRICES SONT TOUTES BASEES SUR LA MEME NUMEROTATION ?
!
    call dismoi('NOM_NUME_DDL', matr_rigi, 'MATR_ASSE', repk=numdl1)
    call dismoi('NOM_NUME_DDL', matr_mass, 'MATR_ASSE', repk=numdl2)
    if (l_damp) then
        call dismoi('NOM_NUME_DDL', matr_damp, 'MATR_ASSE', repk=numdl3)
    else
        numdl3 = numdl2
    endif
!
    if ((numdl1.ne.numdl2) .or. (numdl1.ne.numdl3) .or. (numdl2.ne.numdl3)) then
        call utmess('F', 'DYNALINE1_34')
    else
        numddl = numdl2
    endif
!
! - Create damping matrix from reduced modal damping
!
    call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=0, nbret=n1)
    call getvid('AMOR_MODAL', 'LIST_AMOR'  , iocc=1, nbval=0, nbret=n2)
    if (n1 .ne. 0 .or. n2 .ne. 0) then
        l_damp_modal = ASTER_TRUE
        call gettco(matr_rigi, typobj)
        if (typobj(1:14) .ne. 'MATR_ASSE_GENE') then
            call utmess('F', 'DYNALINE1_95')
        endif
! ----- Number of reduced damping coefficients
        if (n1 .eq. 0) then
            call getvid('AMOR_MODAL', 'LIST_AMOR', iocc=1, scal=list_damp, nbret=n)
            call jelira(list_damp//'           .VALE', 'LONMAX', nb_damp_read)
        else
            nb_damp_read = -n1
        endif
! ----- Get list of reduced damping coefficients
        AS_ALLOCATE(vr = l_damp_read, size = nb_damp_read)
        if (n1 .eq. 0) then
            call jeveuo(list_damp//'           .VALE', 'L', vr = v_list)
        else
            call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=nb_damp_read, vect=l_damp_read,&
                        nbret=n)
        endif
! ----- Create damping matrix from reduced modal damping
        call dl_CreateDampMatrix(matr_rigi   , matr_mass  , l_cplx,&
                                 nb_damp_read, l_damp_read,&
                                 matr_damp)
        AS_DEALLOCATE(vr = l_damp_read)
    endif
!
! - Impedance
!
    if (l_impe) then
        call mtdscr(matr_impe)
    endif
!
! - Linear combiantion
!
    l_harm = ASTER_TRUE
    call dl_MatrixPrepare(l_harm   , l_damp   , l_damp_modal, l_impe   , resu_type,&
                          matr_mass, matr_rigi, matr_damp   , matr_impe,&
                          nb_matr  , matr_list, coef_type   , coef_vale,&
                          matr_res8)
    if (l_damp_modal) then
        matr_damp = ' '
    endif
!
    matr_resu = matr_res8
!
    call jedema()
!
end subroutine
