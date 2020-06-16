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
subroutine te0360(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/eiangl.h"
#include "asterfort/eifint.h"
#include "asterfort/eiinit.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_INTERFACE
!           PLAN_INTERFACE, AXIS_INTERFACE
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
    character(len=16) :: defo_comp
    character(len=8) :: typmod(2), lielrf(10)
    aster_logical :: axi
    integer :: nno1, nno2, npg, imatuu, lgpg
    integer :: iw, ivf1, igeom, imate
    integer :: ivf2, idf2
    integer :: ivarim, ivarip, iinstm, iinstp
    integer :: iddlm, iddld, icompo, icarcr, icamas
    integer :: ivectu, icontp, ivarix
    integer :: jtab(7)
    integer :: ndim, iret, ntrou
    integer :: iu(3, 18), im(3, 9), it(18)
    real(kind=8) :: ang(24)
    aster_logical :: lVect, lMatr, lVari, lSigm
    integer :: codret
    integer :: jv_codret
!
! --------------------------------------------------------------------------------------------------
!
    ivectu = 1
    icontp = 1
    ivarip = 1
    imatuu = 1
    axi    = lteatt('AXIS','OUI')
    codret = 0
!
! - Get element parameters
!
    call elref2(nomte, 2, lielrf, ntrou)
    call elrefe_info(elrefe=lielrf(1), fami='RIGI', ndim=ndim, nno=nno1,&
                     npg=npg, jpoids=iw, jvf=ivf1)
    call elrefe_info(elrefe=lielrf(2), fami='RIGI', ndim=ndim, nno=nno2,&
                     npg=npg, jpoids=iw, jvf=ivf2, jdfde=idf2)
    ndim = ndim + 1
!
! - DECALAGE D'INDICE POUR LES ELEMENTS D'INTERFACE
    call eiinit(nomte, iu, im, it)
!
! - Type of finite element
!
    if (ndim .eq. 3) then
        typmod(1) = '3D'
    else if (axi) then
        typmod(1) = 'AXIS'
    else
        typmod(1) = 'PLAN'
    endif
    typmod(2) = 'INTERFAC'
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', iddlm)
    call jevech('PDEPLPR', 'L', iddld)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
!
! - Properties of behaviour
!
    defo_comp = zk16(icompo-1+DEFO)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! --- ORIENTATION DE L'ELEMENT D'INTERFACE : REPERE LOCAL
!     RECUPERATION DES ANGLES NAUTIQUES DEFINIS PAR AFFE_CARA_ELEM
!
    call jevech('PCAMASS', 'L', icamas)
    if (zr(icamas) .eq. -1.d0) then
        call utmess('F', 'JOINT1_47')
    endif
!
!     DEFINITION DES ANGLES NAUTIQUES AUX NOEUDS SOMMETS : ANG
!
    call eiangl(ndim, nno2, zr(icamas+1), ang)
!
! - Total number of internal state variables on element
!
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - VARIABLES DE COMMANDE
!
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    endif
!
! - FORCES INTERIEURES ET MATRICE TANGENTE
!
    if (defo_comp(1:5) .eq. 'PETIT') then
        call eifint(ndim, axi, nno1, nno2, npg,&
                    zr(iw), zr(ivf1), zr(ivf2), zr(idf2), zr(igeom),&
                    ang, typmod, option, zi(imate), zk16(icompo),&
                    lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm),&
                    zr(iddld), iu, im, zr(ivarim), zr(icontp),&
                    zr(ivarip), zr(imatuu), zr(ivectu),&
                    lMatr, lVect, lSigm,&
                    codret)
    else
        call utmess('F', 'JOINT1_2', sk=defo_comp)
    endif
!
    if (lSigm) then
        call jevech('PCODRET', 'E', jv_codret)
        zi(jv_codret) = codret
    endif
!
end subroutine
