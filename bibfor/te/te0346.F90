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

subroutine te0346(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/jspgno.h"
#include "asterfort/lcsovn.h"
#include "asterfort/lonele.h"
#include "asterfort/matrot.h"
#include "asterfort/nmvmpo.h"
#include "asterfort/porea1.h"
#include "asterfort/pouex7.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/ptkg20.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "blas/ddot.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: POU_D_TG
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
    integer :: nno, nc, i, j, jcret, npg, ipoids
    integer :: igeom, imate, icontm, iorien, icompo, iinstp
    integer :: ideplm, ideplp, iinstm, ivectu, icontp, imat
    integer :: istrxm, istrxp, ldep, codret
    character(len=4) :: fami
    character(len=16) :: rela_comp, defo_comp
    aster_logical :: reactu
    aster_logical :: lVect, lMatr, lVari, lSigm
    real(kind=8) :: u(14), du(14), fl(14), pgl(3, 3), klv(105)
    real(kind=8) :: ey, ez, gamma, xl
    real(kind=8) :: b(14), rgeom(105), angp(3)
    real(kind=8) :: a, xiy, xiz, iyr2, izr2
! --------------------------------------------------------------------------------------------------
    integer, parameter :: nb_cara = 11
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8), parameter :: noms_cara(nb_cara) = (/'A1   ','IY1  ','IZ1  ',&
                                                          'AY1  ','AZ1  ','EY1  ',&
                                                          'EZ1  ','JX1  ','JG1  ',&
                                                          'IYR21','IZR21'/)
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    imat   = 1
    ivectu = 1
    jcret  = 1
    fami = 'RIGI'
    call elrefe_info(fami=fami, nno=nno, npg=npg, jpoids=ipoids)
    nc = 7
!
!   Longueur de l'élément et pointeur sur la géométrie
    xl = lonele(igeom=igeom)
!
! - Get input fields
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PCAORIE', 'L', iorien)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call jevech('PDEPLMR', 'L', ideplm)
!
!   la présence du champ de déplacement à l'instant T+
!   devrait être conditionné  par l'option (avec RIGI_MECA_TANG cela n'a pas de sens).
!   cependant ce champ est initialisé à 0 par la routine nmmatr.
    call jevech('PDEPLPR', 'L', ideplp)
    call poutre_modloc('CAGNP1', noms_cara, nb_cara, lvaleur=vale_cara)
!
! - Properties of behaviour
!
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
!
! - Some checks
!
    if (rela_comp .ne. 'ELAS') then
        call utmess('F', 'POUTRE0_17')
    endif
    if (defo_comp .ne. 'PETIT' .and.  defo_comp .ne. 'GROT_GDEP') then
        call utmess('F', 'POUTRE0_40', sk = defo_comp)
    endif
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imat)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
!
    reactu = defo_comp .eq. 'GROT_GDEP'
    if (reactu) then
!       récupération du 3ème angle nautique au temps T-
        call jevech('PSTRXMR', 'L', istrxm)
        gamma = zr(istrxm+3-1)
!       calcul de pgl,xl et angp
        call porea1(nno, nc, zr(ideplm), zr(ideplp), zr(igeom+1), gamma, lVect, pgl, xl, angp)
!       sauvegarde des angles nautiques
        if (lVari) then
            call jevech('PSTRXPR', 'E', istrxp)
            zr(istrxp+1-1) = angp(1)
            zr(istrxp+2-1) = angp(2)
            zr(istrxp+3-1) = angp(3)
        endif
    else
        call matrot(zr(iorien), pgl)
    endif
!
!   passage des déplacements dans le repère local:
    call utpvgl(nno, nc, pgl, zr(ideplp), du)
    call utpvgl(nno, nc, pgl, zr(ideplm), u)
!
!   passage de G (centre de gravite) à C (centre de torsion)
    ey = vale_cara(6)
    ez = vale_cara(7)
    do i = 1, nno
        j=nc*(i-1)
        u(j+2) = u(j+2) - ez* u(j+4)
        u(j+3) = u(j+3) + ey* u(j+4)
        du(j+2) = du(j+2) - ez*du(j+4)
        du(j+3) = du(j+3) + ey*du(j+4)
    enddo
!
    call nmvmpo(fami, npg, nno, option, nc,&
                xl, zr(ipoids), zi(imate), vale_cara, u,&
                du, zr(icontm), zr(icontp), fl, klv)
!   FL dans le repère global
    if (lVect) then
        fl( 4)=fl( 4)-ez*fl(2)+ey*fl( 3)
        fl(11)=fl(11)-ez*fl(9)+ey*fl(10)
        call utpvlg(nno, nc, pgl, fl, zr(ivectu))
    endif
!
    if (lMatr) then
!       calcul de la matrice de rigidité géométrique
        if (reactu) then
            if (option .eq. 'FULL_MECA') then
                ldep = icontp
            else
                ldep = icontm
            endif
            call jspgno(xl, zr(ldep), b)
            do i = 1, 7
                b(i) = -b(i)
            enddo
            a = vale_cara(1)
            xiy = vale_cara(2)
            xiz = vale_cara(3)
            iyr2= vale_cara(10)
            izr2= vale_cara(11)
            rgeom(:)=0.0d0
            call ptkg20(b, a, xiz, xiy, iyr2, izr2, xl, ey, ez, rgeom)
            call lcsovn(105, klv, rgeom, klv)
        endif
    endif
!
!   Matrice tangente
    if (lMatr) then
        call pouex7(klv, ey, ez)
        call utpslg(nno, nc, pgl, klv, zr(imat))
    endif
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
end subroutine
