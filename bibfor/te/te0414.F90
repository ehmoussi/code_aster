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
subroutine te0414(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cosiro.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/matpgl.h"
#include "asterfort/tranlg.h"
#include "asterfort/utmess.h"
#include "asterfort/vdgnlr.h"
#include "asterfort/vdpnlr.h"
#include "asterfort/vdxnlr.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: COQUE_3D
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb1, jcret, codret
    real(kind=8) :: matloc(51, 51), plg(9, 3, 3)
    integer :: i, i1, i2, ibid, icompo, ideplm, ideplp
    integer :: jgeom, jmatr, lzr, nb2, nddlet, lzi
    character(len=16) :: defo_comp, rela_comp
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
    nb2 = zi(lzi-1+2)
!
! - Get input fields
!
    call cosiro(nomte, 'PCONTMR', 'L', 'UI', 'G', ibid, 'S')
    call jevech('PGEOMER', 'L', jgeom)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCOMPOR', 'L', icompo)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Properties of behaviour
!
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', jmatr)
    endif
    if (lSigm) then
        call jevech('PCODRET', 'E', jcret)
    endif
!
! - Some checks
!
    if (rela_comp(1:5) .eq. 'ELAS_') then
        call utmess('F', 'PLATE1_12', sk=rela_comp)
    endif
!
! - Compute
!
    if (defo_comp .eq. 'GROT_GDEP') then
        if (rela_comp .eq. 'ELAS ') then
!           HYPER-ELASTICITE
            call vdgnlr(lMatr, lVect, lSigm, lVari, rela_comp, nomte)
            goto 999
        else
!           HYPO-ELASTICITE
            call vdpnlr(option, nomte, codret)
            goto 999
        endif
    else if (defo_comp(1:5) .eq. 'PETIT') then
        if (defo_comp(6:10) .eq. '_REAC') then
            call utmess('A', 'PLATE1_13')
            do i = 1, nb2-1
                i1=3*(i-1)
                i2=6*(i-1)
                zr(jgeom+i1) = zr(jgeom+i1) +zr(ideplm+i2) +zr(ideplp+ i2)
                zr(jgeom+i1+1) = zr(jgeom+i1+1)+zr(ideplm+i2+1) +zr(ideplp+i2+1)
                zr(jgeom+i1+2) = zr(jgeom+i1+2)+zr(ideplm+i2+2) +zr(ideplp+i2+2)
            end do
        endif
!
        call vdxnlr(option, nomte, zr(jgeom), matloc, nb1, codret)
!
        if (lMatr) then
! -----    MATRICE DE PASSAGE REPERE GLOBAL REPERE LOCAL
            call jevete('&INEL.'//nomte(1:8)//'.DESR', ' ', lzr)
            call matpgl(nb2, zr(lzr), plg)
! -----    OPERATION DE TRANFORMATION DE MATLOC DANS LE REPERE GLOBAL ET STOCKAGE DANS ZR
            nddlet = 6*nb1+3
            call tranlg(nb1, 51, nddlet, plg, matloc, zr(jmatr))
        endif
    else
        call utmess('F', 'PLATE1_14', sk=defo_comp)
    endif
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
999 continue
!
    if (lSigm) then
        call cosiro(nomte, 'PCONTPR', 'E', 'IU', 'G', ibid, 'R')
    endif
!
end subroutine
