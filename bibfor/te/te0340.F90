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
subroutine te0340(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cgfint.h"
#include "asterfort/cginit.h"
#include "asterfort/cgtang.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: CABLE_GAINE
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
    character(len=8) :: typmod(2), lielrf(10)
    integer :: nno1, nno2, npg, imatuu, lgpg, lgpg1, lgpg2
    integer :: iw, ivf1, idf1, igeom, imate
    integer :: npgn, idf1n
    integer :: ivf2, ino, i, nddl1
    integer :: ivarim, ivarip, iinstm, iinstp
    integer :: iddlm, iddld, icompo, icarcr
    integer :: ivectu, icontp
    integer :: ivarix
    integer :: jtab(7), jcret, codret
    integer :: ndim, iret, ntrou
    integer :: iu(3, 3), iuc(3), im(3), isect, icontm
    real(kind=8) :: tang(3, 3), a, geom(3, 3)
    character(len=16) :: defo_comp, rela_comp, rela_cpla
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    codret = 0
    imatuu=1
    ivectu=1
    icontp=1
    ivarip=1
!
! - FONCTIONS DE FORME
!
    call elref2(nomte, 2, lielrf, ntrou)
    call elrefe_info(elrefe=lielrf(1),fami='RIGI',&
                     jvf=ivf1,jdfde=idf1)
    call elrefe_info(elrefe=lielrf(1),fami='NOEU',nno=nno1,&
                     npg=npgn,jdfde=idf1n)
    call elrefe_info(elrefe=lielrf(2),fami='RIGI',nno=nno2,&
                     npg=npg,jpoids=iw,jvf=ivf2)
    ndim  = 3
    nddl1 = 5
!
! - DECALAGE D'INDICE POUR LES ELEMENTS D'INTERFACE
    call cginit(nomte, iu, iuc, im)
!
! - TYPE DE MODELISATION
!
    typmod(1) = '1D'
    typmod(2) = ' '

!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', iddlm)
    call jevech('PDEPLPR', 'L', iddld)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PCAGNBA', 'L', isect)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
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
    rela_cpla = zk16(icompo-1+PLANESTRESS)
!
!     MISE A JOUR EVENTUELLE DE LA GEOMETRIE
!
    if (defo_comp .eq. 'PETIT') then
        do ino = 1, nno1
            do i = 1, ndim
                geom(i,ino) = zr(igeom-1+(ino-1)*ndim+i)
            enddo
        enddo
    elseif (defo_comp .eq. 'PETIT_REAC') then
        do ino = 1, nno1
            do i = 1, ndim
                geom(i,ino) = zr(igeom-1+(ino-1)*ndim+i)&
                            + zr(iddlm-1+(ino-1)*nddl1+i)&
                            + zr(iddld-1+(ino-1)*nddl1+i)
            enddo
        enddo
    else
        call utmess('F', 'CABLE0_6', sk=defo_comp)
    endif
!
!     DEFINITION DES TANGENTES
!
    call cgtang(3, nno1, npgn, geom, zr(idf1n), tang)
!
!     SECTION DE LA BARRE
    a = zr(isect)
!
! - ON VERIFIE QUE PVARIMR ET PVARIPR ONT LE MEME NOMBRE DE V.I. :
!
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg1 = max(jtab(6),1)*jtab(7)
!
    if (lVari) then
        call tecach('OOO', 'PVARIPR', 'E', iret, nval=7, itab=jtab)
        lgpg2 = max(jtab(6),1)*jtab(7)
        ASSERT(lgpg1 .eq. lgpg2)
    endif
    lgpg = lgpg1
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUNS', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    endif
!
! - FORCES INTERIEURES ET MATRICE TANGENTE
!
    call cgfint(ndim, nno1, nno2, npg, zr(iw),&
                zr(ivf1), zr(ivf2), zr(idf1), geom, tang,&
                typmod, option, zi(imate), zk16(icompo), lgpg,&
                zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm), zr(iddld),&
                iu, iuc, im, a, zr(icontm),&
                zr(ivarim), zr(icontp), zr(ivarip), zr( imatuu), zr(ivectu),&
                codret)
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
end subroutine
