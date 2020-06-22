! --------------------------------------------------------------------
! Copyright (C) 2007 NECS - BRUNO ZUBER   WWW.NECS.FR
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
subroutine te0206(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/gedisc.h"
#include "asterfort/jevech.h"
#include "asterfort/nmfi3d.h"
#include "asterfort/tecach.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/assert.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_JOINT
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
    integer :: nno, npg, nddl
    integer :: ipoids, ivf, idfde
    integer :: igeom, imater, icarcr, icomp, idepm, iddep, icoret
    integer :: icontm, icontp, ivect, imatr
    integer :: ivarim, ivarip, jtab(7), iret, iinstm, iinstp
    integer :: lgpg, codret
!     COORDONNEES POINT DE GAUSS + POIDS : X,Y,Z,W => 1ER INDICE
    real(kind=8) :: coopg(4, 4)
    character(len=16) :: rela_comp
    aster_logical :: matsym
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    ivarip=1
    icoret=1
    icontp=1
    ivect=1
    icoret=1
    imatr = 1
!
! -  FONCTIONS DE FORMES ET POINTS DE GAUSS : ATTENTION CELA CORRESPOND
!    ICI AUX FONCTIONS DE FORMES 2D DES FACES DES MAILLES JOINT 3D
!    PAR EXEMPLE FONCTION DE FORME DU QUAD4 POUR LES HEXA8.
!
    call elrefe_info(fami='RIGI', nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
    nddl = 6*nno
!
    ASSERT(nno .le. 4)
    ASSERT(npg .le. 4)
!
! - LECTURE DES PARAMETRES
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imater)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PDEPLMR', 'L', idepm)
    call jevech('PDEPLPR', 'L', iddep)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
!     CALCUL DES COORDONNEES DES POINTS DE GAUSS, POIDS=0
    call gedisc(3, nno, npg, zr(ivf), zr(igeom),&
                coopg)
!
!     RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icomp),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Properties of behaviour
!
    rela_comp = zk16(icomp-1+RELA_NAME)
!
! - Get output fields
!
    if (lMatr) then
        matsym = .true.
        if (rela_comp .eq. 'JOINT_MECA_RUPT') matsym = .false.
        if (rela_comp .eq. 'JOINT_MECA_FROT') matsym = .false.
        if (matsym) then
            call jevech('PMATUUR', 'E', imatr)
        else
            call jevech('PMATUNS', 'E', imatr)
        endif
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivect)
    endif
!
    call nmfi3d(nno, nddl, npg, lgpg, zr(ipoids),&
                zr(ivf), zr(idfde), zi(imater), option, zr(igeom),&
                zr(idepm), zr(iddep), zr(icontm), zr(icontp), zr(ivect),&
                zr(imatr), zr(ivarim), zr(ivarip), zr(icarcr), zk16(icomp),&
                matsym, coopg, zr(iinstm), zr(iinstp), lMatr, lVect, lSigm,&
                codret)
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', icoret)
        zi(icoret) = codret
    endif
!
end subroutine
