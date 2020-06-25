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
subroutine te0248(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterfort/angvx.h"
#include "asterfort/comp1d.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/nmasym.h"
#include "asterfort/nmiclb.h"
#include "asterfort/nmmaba.h"
#include "asterfort/nmpime.h"
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "blas/dcopy.h"
#include "blas/ddot.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: BARRE / 2D_BARRE
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
    integer :: neq, nbt, nvamax, imate, igeom, iorie, isect, iinstm, ivarmp
    integer :: iinstp, ideplm, ideplp, icontm, ivarim, icompo
    integer :: icarcr, imatuu, ivectu, icontp, nno, nc, ivarip, jcret, nbvari
    integer :: jtab(7), iret
    parameter (neq=6,nbt=21,nvamax=8)
    character(len=4) :: fami
!
!   constantes pour PINTO_MENEGOTTO
    integer :: ncstpm, codret
    parameter (ncstpm=13)
    real(kind=8) :: cstpm(ncstpm)
!
    real(kind=8) :: e, epsm
    real(kind=8) :: aire, xlong0, xlongm, sigy, dsde
    real(kind=8) :: pgl(3, 3)
    real(kind=8) :: dul(neq), uml(neq), dlong
    real(kind=8) :: klv(nbt), vip(nvamax), vim(nvamax)
    real(kind=8) :: effnom, effnop, fono(neq)
    real(kind=8) :: w(6), ang1(3), xd(3), matuu(21), vectu(6)
    real(kind=8) :: deplm(6), deplp(6), sigx, epsx, depx, sigxp
    real(kind=8) :: etan
    real(kind=8) :: angmas(3)
    integer :: i
    character(len=16) :: defo_comp, rela_comp, rela_cpla
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    codret=0
    fami = 'RIGI'
!
! - Get input fields
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCAORIE', 'L', iorie)
    call jevech('PCAGNBA', 'L', isect)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
!   La présence du champ de déplacement a l'instant t+ devrait être conditionnée par l'option
!   (mais avec RIGI_MECA_TANG cela n'a pas de sens).
!   Cependant ce champ est initialisé à 0 par la routine nmmatr.
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
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
! - Some checks
!
    if ( (option.eq. 'FULL_MECA_ELAS' .or. option.eq.'RIGI_MECA_ELAS') .and. &
         (rela_comp .ne. 'ELAS') ) then
        call utmess('F', 'POUTRE0_43', sk = rela_comp)
    endif
!
!   Angle du mot clef MASSIF de AFFE_CARA_ELEM, initialisé à r8nnem (on ne s'en sert pas)
!
    angmas = r8nnem()
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)

    endif
    if (option(1:10) .eq. 'RIGI_MECA_') then
        ivarip = ivarim
        icontp = icontm
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
    endif
    if (option(1:16) .eq. 'RIGI_MECA_IMPLEX') then
        call jevech('PCONTXR', 'E', icontp)
    endif
!
!   Récupération de la section de la barre
    aire = zr(isect)
    nno = 2
    nc = 3
!
!   Récupération des orientations bêta,gamma et calcul des matrices de changement de repère
    if (defo_comp(6:10) .eq. '_REAC') then
        if (nomte .eq. 'MECA_BARRE') then
            do i = 1, 3
                w(i)   = zr(igeom-1+i) + zr(ideplm-1+i) + zr(ideplp-1+i)
                w(i+3) = zr(igeom+2+i) + zr(ideplm+2+i) + zr(ideplp+2+ i)
                xd(i)  = w(i+3) - w(i)
            enddo
        else if (nomte.eq.'MECA_2D_BARRE') then
            w(1)  = zr(igeom-1+1) + zr(ideplm-1+1) + zr(ideplp-1+1)
            w(2)  = zr(igeom-1+2) + zr(ideplm-1+2) + zr(ideplp-1+2)
            w(3)  = 0.d0
            w(4)  = zr(igeom-1+3) + zr(ideplm-1+3) + zr(ideplp-1+3)
            w(5)  = zr(igeom-1+4) + zr(ideplm-1+4) + zr(ideplp-1+4)
            w(6)  = 0.d0
            xd(1) = w(4) - w(1)
            xd(2) = w(5) - w(2)
            xd(3) = 0.d0
        endif
        call angvx(xd, ang1(1), ang1(2))
        ang1(3) = zr(iorie+2)
        call matrot(ang1, pgl)
    else
        if (nomte .eq. 'MECA_BARRE') then
            do i = 1, 3
                w(i)   = zr(igeom-1+i)
                w(i+3) = zr(igeom+2+i)
                xd(i)  = w(i+3) - w(i)
            enddo
        else if (nomte.eq.'MECA_2D_BARRE') then
            w(1)  = zr(igeom-1+1)
            w(2)  = zr(igeom-1+2)
            w(3)  = 0.d0
            w(4)  = zr(igeom-1+3)
            w(5)  = zr(igeom-1+4)
            w(6)  = 0.d0
            xd(1) = w(4) - w(1)
            xd(2) = w(5) - w(2)
            xd(3) = 0.d0
        endif
        call matrot(zr(iorie), pgl)
    endif
!
    xlong0=ddot(3,xd,1,xd,1)
    xlong0 = sqrt(xlong0)
!
    if (xlong0 .eq. 0.d0) then
        call utmess('F', 'POUTRE0_62')
    endif
!
!   Incrément de déplacement en repère local
    if (nomte .eq. 'MECA_BARRE') then
        do i = 1, 6
            deplm(i) = zr(ideplm+i-1)
            deplp(i) = zr(ideplp+i-1)
        enddo
    else if (nomte.eq.'MECA_2D_BARRE') then
        deplm(1) = zr(ideplm)
        deplm(2) = zr(ideplm+1)
        deplm(3) = 0.d0
        deplm(4) = zr(ideplm+2)
        deplm(5) = zr(ideplm+3)
        deplm(6) = 0.d0
!
        deplp(1) = zr(ideplp)
        deplp(2) = zr(ideplp+1)
        deplp(3) = 0.d0
        deplp(4) = zr(ideplp+2)
        deplp(5) = zr(ideplp+3)
        deplp(6) = 0.d0
    endif
!
    call utpvgl(nno, nc, pgl, deplm, uml)
    call utpvgl(nno, nc, pgl, deplp, dul)
!
    dlong = dul(4) - dul(1)
    xlongm = xlong0 + uml(4) - uml(1)
!   Récupération de l'effort normal précédent moyen effnom pour l'élément
    effnom = zr(icontm)
!
!   RELATION DE COMPORTEMENT
    if ( (rela_comp .eq. 'ELAS') .or. &
         (rela_comp .eq. 'VMIS_ISOT_LINE') .or. &
         (rela_comp .eq. 'VMIS_ISOT_TRAC') .or. &
         (rela_comp .eq. 'CORR_ACIER') .or. &
         (rela_comp .eq. 'VMIS_CINE_LINE') .or. &
         (rela_comp .eq. 'RELAX_ACIER') ) then
!       Récupération des caractéristiques du matériau
        epsm = (uml(4)-uml(1))/xlong0
        call nmiclb(fami, 1, 1, option, rela_comp,&
                    zi(imate), xlong0, aire, zr(iinstm), zr(iinstp),&
                    dlong, effnom, zr(ivarim), effnop, zr(ivarip),&
                    klv, fono, epsm, zr(icarcr), codret)
!
        if (option(1:16) .eq. 'RIGI_MECA_IMPLEX') then
            zr(icontp) = effnop
        endif
!
        if (option(1:10) .eq. 'RIGI_MECA_') then
            call utpslg(nno, nc, pgl, klv, matuu)
        else
            zr(icontp) = effnop
            if (option(1:9) .eq. 'FULL_MECA') then
                call utpslg(nno, nc, pgl, klv, matuu)
            endif
            call utpvlg(nno, nc, pgl, fono, vectu)
        endif
!
    else if (rela_comp .eq. 'VMIS_ASYM_LINE') then
!       Récupération des caractéristiques du matériau
        call nmmaba(zi(imate), rela_comp, e, dsde, sigy,&
                    ncstpm, cstpm)
!
        call nmasym(fami, 1, 1, zi(imate), option,&
                    xlong0, aire, zr(iinstm), zr( iinstp), dlong,&
                    effnom, zr(ivarim), zr(icontp), zr(ivarip), klv,&
                    fono)
!
        if (option(1:10) .eq. 'RIGI_MECA_') then
            call utpslg(nno, nc, pgl, klv, matuu)
        else
            if (option(1:9) .eq. 'FULL_MECA') then
                call utpslg(nno, nc, pgl, klv, matuu)
            endif
            call utpvlg(nno, nc, pgl, fono, vectu)
        endif
!
    else if (rela_comp .eq. 'PINTO_MENEGOTTO') then
!       Récupération des caractéristiques du matériau
        call nmmaba(zi(imate), rela_comp, e, dsde, sigy,&
                    ncstpm, cstpm)
!
        vim(1) = zr(ivarim)
        vim(2) = zr(ivarim+1)
        vim(3) = zr(ivarim+2)
        vim(4) = zr(ivarim+3)
        vim(5) = zr(ivarim+4)
        vim(6) = zr(ivarim+5)
        vim(7) = zr(ivarim+6)
        vim(8) = zr(ivarim+7)
        call nmpime(fami, 1, 1, zi(imate), option,&
                    xlong0, aire, xlongm, dlong, ncstpm,&
                    cstpm, vim, effnom, vip, effnop,&
                    klv, fono)
!
        if (option(1:10) .eq. 'RIGI_MECA_') then
            call utpslg(nno, nc, pgl, klv, matuu)
        else
            zr(icontp) = effnop
            if (option(1:9) .eq. 'FULL_MECA') then
                call utpslg(nno, nc, pgl, klv, matuu)
            endif
            zr(ivarip)   = vip(1)
            zr(ivarip+1) = vip(2)
            zr(ivarip+2) = vip(3)
            zr(ivarip+3) = vip(4)
            zr(ivarip+4) = vip(5)
            zr(ivarip+5) = vip(6)
            zr(ivarip+6) = vip(7)
            zr(ivarip+7) = vip(8)
            call utpvlg(nno, nc, pgl, fono, vectu)
        endif
!
    else
!       Double DEBORST : risque d'impact sur les performances d'intégration de la loi
        call r8inir(neq, 0.d0, fono, 1)
        call r8inir(nbt, 0.d0, klv, 1)
!

        if ((rela_cpla.ne.'DEBORST') .and. (rela_comp .ne. 'SANS')) then
            call utmess('F', 'COMPOR4_32', sk = rela_comp)
        else
!
            sigx=effnom/aire
            epsx=(uml(4)-uml(1))/xlong0
            depx=dlong/xlong0
!
            if (lVect) then
                call tecach('OOO', 'PVARIMP', 'L', iret, nval=7, itab=jtab)
                nbvari = max(jtab(6),1)*jtab(7)
                ivarmp=jtab(1)
                call dcopy(nbvari, zr(ivarmp), 1, zr(ivarip), 1)
            endif
!
            call comp1d(fami, 1, 1, option, sigx,&
                        epsx, depx, angmas, zr(ivarim), zr(ivarip),&
                        sigxp, etan, codret)
!
            if (lVect) then
!               stockage de l'effort normal
                zr(icontp) = sigxp*aire
!               calcul des forces nodales
                fono(1) = -sigxp*aire
                fono(4) = sigxp*aire
            endif
!           calcul de la matrice tangente
            klv(1) = etan
            klv(7) = -etan
            klv(10) = etan
        endif
!
!       passage de klv et fono du repère local au repère global
        if (lMatr) then
            call utpslg(nno, nc, pgl, klv, matuu)
        endif
        if (lVect) then
            call utpvlg(nno, nc, pgl, fono, vectu)
        endif
!
    endif
!
    if (nomte .eq. 'MECA_BARRE') then
        if (lMatr) then
            do i = 1, 21
                zr(imatuu+i-1) = matuu(i)
            enddo
        endif
        if (lVect) then
            do i = 1, 6
                zr(ivectu+i-1) = vectu(i)
            enddo
        endif
!
    else if (nomte.eq.'MECA_2D_BARRE') then
        if (lMatr) then
            zr(imatuu) = matuu(1)
            zr(imatuu+1) = matuu(2)
            zr(imatuu+2) = matuu(3)
            zr(imatuu+3) = matuu(7)
            zr(imatuu+4) = matuu(8)
            zr(imatuu+5) = matuu(10)
            zr(imatuu+6) = matuu(11)
            zr(imatuu+7) = matuu(12)
            zr(imatuu+8) = matuu(14)
            zr(imatuu+9) = matuu(15)
        endif
        if (lVect) then
            zr(ivectu) = vectu(1)
            zr(ivectu+1) = vectu(2)
            zr(ivectu+2) = vectu(4)
            zr(ivectu+3) = vectu(5)
        endif
!
    endif
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
end subroutine
