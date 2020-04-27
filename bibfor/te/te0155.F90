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

subroutine te0155(option, nomte)
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DES FORCES ELEMENTAIRES LINEIQUES
!
!     CALCUL DU CHARGEMENT INDUIT PAR UNE ELEVATION UNIFORME DE  TEMPERATURE
!
! --------------------------------------------------------------------------------------------------
!
! option : nom de l'option à calculer
!       CHAR_MECA_PESA_R    : charges de pesanteur
!       CHAR_MECA_FR1D1D    : forces linéiques (réelles)
!       CHAR_MECA_FF1D1D    : forces linéiques (fonctions)
!       CHAR_MECA_SR1D1D    : forces linéiques suiveuses (réelles)
!       CHAR_MECA_SF1D1D    : forces linéiques suiveuses (fonctions)
!       CHAR_MECA_TEMP_R    : élévation de température
!       CHAR_MECA_SECH_R    : séchage
!       CHAR_MECA_HYDR_R    : hydratation
!       CHAR_MECA_EPSI_R    : déformation initiale
!       CHAR_MECA_EPSI_F    : déformation initiale
!
! nomte  :
!       MECA_BARRE      : BARRE
!       MECA_2D_BARRE   : BARRE en 2D
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=*) :: option, nomte
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/angvx.h"
#include "asterfort/assert.h"
#include "asterfort/fointe.h"
#include "asterfort/get_value_mode_local.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/provec.h"
#include "asterfort/pscvec.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/verift.h"
#include "blas/ddot.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: codres(1), dimens, iret
    integer :: nno, nc, lx, lorien, idepla, ideplp, i, lvect
    integer :: lmater, lpesa, lforc, itemps, nbpar, iepsini
    integer :: ifcx, iadzi, iazk24, kpg, spt, ichamp
!
    real(kind=8) :: aire, e(1), rho(1), xl, temper, xdep, xrig, w2(3)
    real(kind=8) :: pgl(3, 3), force_rep_local(6), force(6), ql(6)
    real(kind=8) :: r8min, xss, xs2, xs4, r1, vect(6), epsini
    real(kind=8) :: fcx, vite2, xvp(3), ang1(3), xuu(3), xvv(3),viterela(6)
    real(kind=8) :: kendog(1), kdessi(1), sech, hydr
    real(kind=8) :: epsth, sref
!
    character(len=4)    :: fami
    character(len=8)    :: poum, nomail
!
    logical :: normal, global, okvent
! --------------------------------------------------------------------------------------------------
!
    real(kind=8)                :: valpav(1)
    character(len=8), parameter :: nompav(1) = ['VITE']
!
    real(kind=8)        :: valr(2), valpar(13)
    character(len=8)    :: valp(2), nompar(13)
!
    real(kind=8)        :: wx(6), wv(6), wa(6), temps
!
! --------------------------------------------------------------------------------------------------
!
    r8min = r8miem()
!
    nompar(1:3)   = ['X','Y','Z']
    nompar(4:6)   = ['DX','DY','DZ']
    nompar(7:9)   = ['VITE_X','VITE_Y','VITE_Z']
    nompar(10:12) = ['ACCE_X','ACCE_Y','ACCE_Z']
    nompar(13)    = 'INST'
!
    force(:) = 0.0; wx(:) = 0.0; w2(:) = 0.0; wv(:) = 0.0; wa(:) = 0.0
    temps = 0.0; nbpar = 3
    force_rep_local(:) = 0.0
!
    okvent = .false.; normal = .false.; global = .false.
! --------------------------------------------------------------------------------------------------
    nno  = 2; nc   = 3; fami = 'RIGI'; dimens = 0
    if      (nomte.eq.'MECA_BARRE') then
        dimens = 3
    else if (nomte.eq.'MECA_2D_BARRE') then
        dimens = 2
    else
        ASSERT( .false. )
    endif
!   Récupération des coordonnées des noeuds
    call jevech('PGEOMER', 'L', lx)
!   Récupération des orientations alpha,beta,gamma
    call jevech('PCAORIE', 'L', lorien)
!
    if ( (option.eq.'CHAR_MECA_SR1D1D').or.(option.eq.'CHAR_MECA_SF1D1D')) then
        call jevech('PDEPLMR', 'L', idepla)
        call jevech('PDEPLPR', 'L', ideplp)
!       wx(1 2 3 4 5 6)  => position
!       w2(1 2 3)        => vecteur directeur
        do i = 1, dimens
            wx(i)        = zr(lx-1+i)        + zr(idepla-1+i)        + zr(ideplp-1+i)
            wx(i+dimens) = zr(lx-1+i+dimens) + zr(idepla-1+dimens+i) + zr(ideplp-1+dimens+i)
            w2(i)        = wx(dimens+i) - wx(i)
        enddo
!       wv(1 2 3 4 5 6) => Vitesses
        call tecach('NNO', 'PVITPLU', 'L', iret, iad=ichamp)
        if (iret.eq.0) then
            ASSERT(nomte.ne.'MECA_2D_BARRE')
            do i = 1, 3
                wv(i)        = zr(ichamp-1+i)
                wv(i+dimens) = zr(ichamp-1+i+dimens)
            enddo
        endif
!       wa(1 2 3 4 5 6) => Accélérations
        call tecach('NNN', 'PACCPLU', 'L', iret, iad=ichamp)
        if ( iret.eq.0 ) then
            ASSERT(nomte.ne.'MECA_2D_BARRE')
            do i = 1, 3
                wa(i)        = zr(ichamp+i-1)
                wa(i+dimens) = zr(ichamp+i+dimens-1)
            enddo
        endif
        call angvx(w2, ang1(1), ang1(2))
        ang1(3) = zr(lorien+2)
        call matrot(ang1, pgl)
    else
        do i = 1, dimens
            wx(i)        = zr(lx-1+i)
            wx(i+dimens) = zr(lx-1+dimens+i)
            w2(i)        = wx(i+dimens) - wx(i)
        enddo
        call matrot(zr(lorien), pgl)
    endif
!
!   Si l'élément est de taille nulle
    xss = ddot(dimens,w2,1,w2,1)
    xl = sqrt(xss)
    if (xl.le.r8min) then
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3)(1:8)
        call utmess('F', 'ELEMENTS2_43', sk=nomail)
    endif
!
! --------------------------------------------------------------------------------------------------
!   cas de charge de pesanteur
    if (option.eq.'CHAR_MECA_PESA_R') then
!       Récupération des caractéristiques générales des sections
        valp(1) = 'A1'
        call get_value_mode_local('PCAGNBA', valp, valr, iret, nbpara_=1)
        aire    = valr(1)
!       recuperation des caracteristiques materiaux ---
        call jevech('PMATERC', 'L', lmater)
        kpg=1; spt=1; poum='+'
        call rcvalb('FPG1', kpg, spt, poum, zi(lmater), ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'RHO', rho, codres, 1)
!
        call jevech('PPESANR', 'L', lpesa)
        do i = 1, 3
            force(i)   = rho(1)*zr(lpesa)*zr(lpesa+i)
            force(i+3) = force(i)
        enddo
!       passage repère local du vecteur force
        call utpvgl(nno, nc, pgl, force(1), ql(1))
!       calcul des forces nodales équivalentes en repère local
!           FL(1) = QL(1) * A * XL / 2.D0
!           FL(4) = QL(4) * A * XL / 2.D0
        force_rep_local(1:6) = ql(1:6) * aire *xl /2.d0
! --------------------------------------------------------------------------------------------------
!   Forces Fixes réparties par valeurs réelles
    else if (option.eq.'CHAR_MECA_FR1D1D') then
        call jevech('PFR1D1D', 'L', lforc)
        r1 = abs(zr(lforc+3))
        global = r1 .lt. 0.001
        normal = r1 .gt. 1.001

        do i = 1, 3
            force(i)   = zr(lforc+i-1)
            force(i+3) = force(i)
        enddo
        if (normal) then
            call ForceNormale(w2,force(1))
            call ForceNormale(w2,force(4))
        endif
        if (global .or. normal) then
            call utpvgl(nno, nc, pgl, force(1), ql(1))
        else
            ql(1:6) = force(1:6)
        endif
!       calcul des forces nodales equivalentes en repere local
!           FL(1) = QL(1) * XL / 2.D0
!           FL(4) = QL(4) * XL / 2.D0
        force_rep_local(1:6)= ql(1:6) * xl / 2.d0
! --------------------------------------------------------------------------------------------------
!   Forces Suiveuses réparties par valeurs réelles
    else if (option.eq.'CHAR_MECA_SR1D1D') then
!       Pour le cas du vent
        call tecach('NNO', 'PVITER', 'L', iret, iad=lforc)
        if (lforc .ne. 0) then
            ASSERT(nomte.ne.'MECA_2D_BARRE')
            normal = .true.
            okvent = .true.
            global = .true.
        endif
!       Seul le cas du vent donné par 'PVITER' est accepté
        if (.not. okvent) call utmess('F', 'ELEMENTS3_34')
!       Récupération de la fonction : effort en fonction de la vitesse
        call tecach('ONO', 'PVENTCX', 'L', iret, iad=ifcx)
        if ((iret.ne.0).or.(zk8(ifcx)(1:1).eq.'.')) then
            call utmess('F', 'ELEMENTS3_35')
        endif
!       Récupération de la vitesse de vent relative aux noeuds
        do i = 1, 6
            viterela(i)=zr(lforc-1+i)
        enddo
!
        xss  = ddot(3,w2,1,w2,1)
        xs2  = 1.d0/xss
!       Calcul du vecteur vitesse perpendiculaire : noeud 1
        fcx = 0.0; xvp(:) = 0.0
        xss  = ddot(3,viterela(1),1,viterela(1),1)
        xs4  = sqrt(xss)
        if (xs4 .gt. r8min) then
            call provec(w2, viterela(1), xuu)
            call provec(xuu, w2, xvv)
            call pscvec(3, xs2, xvv, xvp)
!           Norme de la vitesse perpendiculaire
            vite2 = ddot(3,xvp,1,xvp,1)
            valpav(1) = sqrt( vite2 )
            if (valpav(1) .gt. r8min) then
                call fointe('FM', zk8(ifcx), 1, nompav, valpav, fcx, iret)
                fcx = fcx / valpav(1)
            endif
        endif
        call pscvec(3, fcx, xvp, force(1))
!
!       Calcul du vecteur vitesse perpendiculaire : noeud 2
        fcx = 0.0; xvp(:) = 0.0
        xss  = ddot(3,viterela(4),1,viterela(4),1)
        xs4  = sqrt(xss)
        if (xs4 .gt. r8min) then
            call provec(w2, viterela(4), xuu)
            call provec(xuu, w2, xvv)
            call pscvec(3, xs2, xvv, xvp)
!           Norme de la vitesse perpendiculaire
            vite2 = ddot(3,xvp,1,xvp,1)
            valpav(1) = sqrt( vite2 )
            if (valpav(1) .gt. r8min) then
                call fointe('FM', zk8(ifcx), 1, nompav, valpav, fcx, iret)
                fcx = fcx / valpav(1)
            endif
        endif
        call pscvec(3, fcx, xvp, force(4))
!
        call utpvgl(nno, nc, pgl, force(1), ql(1))
!       Calcul des forces nodales équivalentes en repère local
        force_rep_local(1:6)= ql(1:6) * xl / 2.d0
!
! --------------------------------------------------------------------------------------------------
!   Forces Fixes et Suiveuses réparties par Fonctions
    else if ( (option.eq.'CHAR_MECA_FF1D1D').or.(option.eq.'CHAR_MECA_SF1D1D') ) then
        call jevech('PFF1D1D', 'L', lforc)
        normal = zk8(lforc+3) .eq. 'VENT'
        global = zk8(lforc+3) .eq. 'GLOBAL'
        call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (itemps .ne. 0) then
            temps = zr(itemps)
            nbpar = 13
        endif
!
        valpar(1:3) = wx(1:3); valpar(4:6)   = w2(1:3)
        valpar(7:9) = wv(1:3); valpar(10:12) = wa(1:3)
        valpar(13)  = temps
        do i = 1, 3
            call fointe('FM', zk8(lforc+i-1), nbpar, nompar, valpar, force(i),   iret)
        enddo
!
        valpar(1:3) = wx(4:6); valpar(4:6)   = w2(1:3)
        valpar(7:9) = wv(4:6); valpar(10:12) = wa(4:6)
        valpar(13)  = temps
        do i = 1, 3
            call fointe('FM', zk8(lforc+i-1), nbpar, nompar, valpar, force(i+3), iret)
        enddo
!
        if (normal) then
            call ForceNormale(w2,force(1))
            call ForceNormale(w2,force(4))
        endif
        if (global .or. normal) then
            call utpvgl(nno, nc, pgl, force(1), ql(1))
        else
            ql(1:6) = force(1:6)
        endif
!
!       Calcul des forces nodales equivalentes en repere local ---
!           FL(1) = QL(1) * XL / 2.D0
!           FL(4) = QL(4) * XL / 2.D0
        force_rep_local(1:6)= ql(1:6) * xl / 2.d0
!
! --------------------------------------------------------------------------------------------------
!   Températute
    else if (option.eq.'CHAR_MECA_TEMP_R') then
!       Recuperation des caracteristiques generales des sections
        valp(1) = 'A1'
        call get_value_mode_local('PCAGNBA', valp, valr, iret, nbpara_=1)
        aire    = valr(1)
!       Recuperation des caracteristiques materiaux ---
        call jevech('PMATERC', 'L', lmater)
        call rcvalb(fami, 1, 1, '+', zi(lmater), ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', e, codres, 1)
!       Temperature de reference
        call verift(fami, 1, 1, '+', zi(lmater), epsth_=epsth)
!       Terme de la matrice elementaire
        xrig = e(1) * aire / xl
!       Deplacement induit par la temperature
        xdep = epsth * xl
!       Calcul des forces induites
        force_rep_local(1) = -xrig * xdep
        force_rep_local(4) =  xrig * xdep
!
! --------------------------------------------------------------------------------------------------
!   Séchage
    else if (option.eq.'CHAR_MECA_SECH_R') then
!       Recuperation des caracteristiques generales des sections
        valp(1) = 'A1'
        call get_value_mode_local('PCAGNBA', valp, valr, iret, nbpara_=1)
        aire    = valr(1)
!       Recuperation des caracteristiques materiaux
        call jevech('PMATERC', 'L', lmater)
        call rcvalb(fami, 1, 1, '+', zi(lmater), ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', e, codres, 1)
!       Recuperation de l'instant
        call tecach('ONO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (itemps .ne. 0) then
            temps = zr(itemps)
        endif
!       Temperature effective
        call rcvarc(' ', 'TEMP', '+', fami, 1, 1, temper, iret)
        call rcvarc(' ', 'SECH', '+', 'RIGI', 1, 1, sech, iret)
        if (iret .ne. 0) sech=0.d0
        call rcvarc(' ', 'SECH', 'REF', 'RIGI', 1, 1, sref, iret)
        if (iret .ne. 0) sref=0.d0
!
        nompar(1) = 'TEMP'; nompar(2) = 'INST'; nompar(3) = 'SECH'
        valpar(1) = temper; valpar(2) = temps;  valpar(3) = sech
!       Terme de la matrice elementaire
        xrig = e(1) * aire / xl
!       Interpolation de k_dessicca en fonction de la temperature du sechage
        call rcvalb('RIGI', 1, 1, '+', zi(lmater), ' ', 'ELAS', 3, nompar, valpar,&
                    1, 'K_DESSIC', kdessi, codres, 0)
        if (codres(1) .ne. 0) kdessi(1)=0.d0
!
!       Deplacement induit par le sechage
        xdep = -kdessi(1)*(sref-sech) * xl
!       Calcul des forces induites ---
        force_rep_local(1) = -xrig * xdep
        force_rep_local(4) =  xrig * xdep
!
! --------------------------------------------------------------------------------------------------
!   Hydratation
    else if (option.eq.'CHAR_MECA_HYDR_R') then
!       Recuperation des caracteristiques generales des sections
        valp(1) = 'A1'
        call get_value_mode_local('PCAGNBA', valp, valr, iret, nbpara_=1)
        aire    = valr(1)
!       Recuperation des caracteristiques materiaux ---
        call jevech('PMATERC', 'L', lmater)
        call rcvalb('RIGI', 1, 1, '+', zi(lmater), ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', e, codres, 1)
!       Recuperation de l'instant
        call tecach('ONO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (itemps .ne. 0) then
            temps = zr(itemps)
        endif
!       Temperature effective
        call rcvarc(' ', 'TEMP', '+', fami, 1, 1, temper, iret)
!       Hydratation effective
        call rcvarc(' ', 'HYDR', '+', 'RIGI', 1, 1, hydr, iret)
        if (iret .ne. 0) hydr=0.d0
!
        nompar(1) = 'TEMP'; nompar(2) = 'INST'; nompar(3) = 'HYDR'
        valpar(1) = temper; valpar(2) = temps;  valpar(3) = hydr
!       Terme de la matrice elementaire
        xrig = e(1) * aire / xl
!       Interpolation de k_dessicca en fonction de la temperature ou de l hydratation
        call rcvalb('RIGI', 1, 1, '+', zi(lmater), ' ', 'ELAS', 3, nompar, valpar,&
                    1, 'B_ENDOGE', kendog, codres, 0)
        if (codres(1) .ne. 0) kendog(1)=0.d0
!
!       Deplacement induit par le sechage
        xdep = -kendog(1)*hydr * xl
!       CALCUL DES FORCES INDUITES
        force_rep_local(1) = -xrig * xdep
        force_rep_local(4) =  xrig * xdep
!
! --------------------------------------------------------------------------------------------------
!   Déformation
    else if (option(1:15).eq.'CHAR_MECA_EPSI_') then
!       Recuperation des caracteristiques generales des sections
        valp(1) = 'A1'
        call get_value_mode_local('PCAGNBA', valp, valr, iret, nbpara_=1)
        aire    = valr(1)
!       Recuperation des caracteristiques materiaux
        call jevech('PMATERC', 'L', lmater)
        call rcvalb(fami, 1, 1, '+', zi(lmater), ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', e, codres, 1)
!       Recuperation de la deformation
        if (option(15:16).eq.'_R')then
            call jevech('PEPSINR', 'L', iepsini)
            epsini = zr(iepsini)
        else
            call jevech('PEPSINF', 'L', iepsini)
            call jevech('PTEMPSR', 'L', itemps)
            nompar(1:3)   = ['X','Y','Z']
            nompar(4)     = 'INST'
            valpar(1) = (wx(1)+wx(4))/2.d0
            valpar(2) = (wx(2)+wx(5))/2.d0
            valpar(3) = (wx(3)+wx(6))/2.d0
            valpar(4) = zr(itemps)
            call fointe('FM', zk8(iepsini), 4, nompar, valpar, epsini, iret)
        endif
!       Calcul des forces induites
        force_rep_local(1) = -e(1) * aire * epsini
        force_rep_local(4) =  e(1) * aire * epsini
    endif
!
!   Force dans le repère global
    call utpvlg(nno, nc, pgl, force_rep_local(1), vect)
!   Ecriture dans le vecteur PVECTUR
    call jevech('PVECTUR', 'E', lvect)
    if (nomte .eq. 'MECA_BARRE') then
        do i = 1, 6
            zr(lvect+i-1) = vect(i)
        enddo
    else if (nomte.eq.'MECA_2D_BARRE') then
        zr(lvect)   = vect(1)
        zr(lvect+1) = vect(2)
        zr(lvect+2) = vect(4)
        zr(lvect+3) = vect(5)
    endif
!
! ==================================================================================================
!
contains
!
subroutine ForceNormale(w2,force)
!
#include "asterfort/provec.h"
#include "asterfort/pscvec.h"
#include "blas/ddot.h"
#include "asterc/r8miem.h"
!
    real(kind=8), intent(in)    :: w2(3)
    real(kind=8), intent(inout) :: force(3)
!
    real(kind=8) :: xuu(3), xvv(3), xsu(3)
    real(kind=8) :: xss, xs2, xs3, xs4, xs5, r8min
!
    r8min = r8miem()
    xss   = ddot(3,force,1,force,1)
    xs4 = sqrt(xss)
    if (xs4.gt.r8min) then
        xss = ddot(3,w2,1,w2,1)
        xs2 = 1.0/xss
        call provec(w2, force, xuu)
        call provec(xuu, w2, xvv)
        call pscvec(3, xs2, xvv, xsu)
        xss = ddot(3,xuu,1,xuu,1)
        xs3 = sqrt(xss)
        xs5 = xs3*sqrt(xs2)/xs4
        call pscvec(3, xs5, xsu, force)
    endif
end subroutine ForceNormale

end subroutine te0155
