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

subroutine nmcine_line_gc(fami,  kpg,    ksp,    ndim, typmod, &
                          imate, compor, crit,   epsm, deps,   &
                          sigm,  vim,    option, sigp, vip,    &
                          dsidep, iret)
!
! --------------------------------------------------------------------------------------------------
!
!     Écrouissage cinématique en contraintes planes
!
!     Très fortement inspiré de NMECMI
!
! --------------------------------------------------------------------------------------------------
!
! IN
!   fami        famille de point de gauss (rigi,mass,...)
!   kpg, ksp    numéro du (sous)point de gauss
!   ndim        dimension de l espace (3d=3,2d=2,1d=1)
!   typmod      type de modélisation
!   imate       adresse du matériau code
!   compor      comportement de l'élément
!                   compor(1) = relation de comportement
!                   compor(2) = nb de variables internes
!                   compor(3) = type de déformation
!   crit        critères  locaux
!                   crit(1) = nombre d'itérations maxi a convergence (iter_inte_maxi == itecrel)
!                   crit(2) = type de jacobien a t+dt (type_matr_comp == macomp)
!                                   0 = en vitesse     > symétrique
!                                   1 = en incrémental > non-symétrique
!                   crit(3) = valeur de la tolérance de convergence (resi_inte_rela == rescrel)
!                   crit(5) = nombre d'incréments pour le redécoupage local du pas de temps
!                             (iter_inte_pas == itedec)
!                                   0 = pas de redécoupage
!                                   n = nombre de paliers
!   deps        incrément de déformation totale
!   sigm        contrainte  à t-
!   epsm        déformation à t-
!   vim         variables internes a t-
!                   attention "vim" variables internes a t- modifiées si redécoupage local
!   option      option de calcul
!                   'rigi_meca_tang'> dsidep(t)
!                   'full_meca'     > dsidep(t+dt) , sig(t+dt)
!                   'raph_meca'     > sig(t+dt)
!
! OUT
!   sigp        contrainte a t+
!   vip         variables internes a t+
!   dsidep      matrice de comportement tangent
!   iret        code retour
!                   0   Tout va bien
!                   1   Redécoupage global ?
!                   2   Redécoupage local  ?
!
!
! --------------------------------------------------------------------------------------------------
!
!   Attention les tenseurs et matrices sont rangés dans l'ordre
!       XX, YY, ZZ, SQRT(2)*XY, SQRT(2)*XZ, SQRT(2)*YZ
!
!   Codage en dur de "pragm" et "pragp" car pas d'écrouissage isotrope [R5.03.16 §5]
!
! --------------------------------------------------------------------------------------------------
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/assert.h"
#include "asterfort/radial.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "asterfort/zerofr.h"
!
    integer         :: kpg, ksp, ndim, imate, iret
    real(kind=8)    :: crit(10)
    real(kind=8)    :: epsm(6), deps(6), sigm(6), sigp(6), dsidep(6,6)
!
    integer, parameter  :: nbvari = 12
    real(kind=8)        :: vim(nbvari), vip(nbvari)
!
    character(len=*)  :: fami
    character(len=8)  :: typmod(*)
    character(len=16) :: compor(*), option
!
! --------------------------------------------------------------------------------------------------
!   Nom des index des variables internes pour VMIS_CINE_GC et VMIS_CINE_LINE
    integer  :: icels, icelu, iepsq, iplas, idiss, iwthe
    integer  :: ixxm,  iyym,  izzm,  ixym,  ixzm,  iyzm
    integer  :: ivari
!
!   Variables globales (cf. contains)
!       deuxmup, troiskp, sigyp, rprim, pm, sigel(6), pragp
! --------------------------------------------------------------------------------------------------
!
    aster_logical   :: plasti, cinegc, cineli

    integer         :: ndimsi, kk, ll, niter, ibid
!
    real(kind=8)    :: sigedv(6), depsdv(6), sigmdv(6), sigpdv(6), sigdv(6), sigmp(6), sigel(6)
    real(kind=8)    :: depsth(6), xp(6), xm(6), epsicplan(6)
    real(kind=8)    :: depsmo, sigmmo, rprim, rp, hp, gp, g1, rpm, sgels, epelu, pm, plast
    real(kind=8)    :: sieleq, sigeps, seuil, dp, cc, radi, prec, dx
    real(kind=8)    :: hsg, pp, precr, epsthe, sigmels, epsielu, epsmo
    real(kind=8)    :: em, num, deuxmum, troiskm, pragm, dsdem
    real(kind=8)    :: ep, nup, deuxmup, troiskp, pragp, dsdep, sigyp

! --------------------------------------------------------------------------------------------------
    real(kind=8)            :: dp0, xap
    real(kind=8), parameter :: kron(6) = (/1.0,1.0,1.0,0.0,0.0,0.0/)
!
! --------------------------------------------------------------------------------------------------
    real(kind=8)        :: valrm(3)
    character(len=16)   :: valkm(3)
! --------------------------------------------------------------------------------------------------
    integer             :: icodre(4)
    real(kind=8)        :: valres(4)
    character(len=16)   :: nomres(4)
! --------------------------------------------------------------------------------------------------
!
!   Est ce que l'on est bon
    cinegc = compor(1)(1:12).eq.'VMIS_CINE_GC'
    cineli = compor(1)(1:14).eq.'VMIS_CINE_LINE'
!
!   index des variables internes
    if ( cinegc ) then
!       Pour VMIS_CINE_GC
!           'CRITSIG', 'CRITEPS', 'EPSPEQ', 'INDIPLAS', 'DISSIP', 'DISSTHER',
!           'XCINXX',  'XCINYY',  'XCINZZ', 'XCINXY', 'XCINXZ', 'XCINYZ',
        icels=1; icelu=2; iepsq=3; iplas= 4; idiss= 5; iwthe= 6
        ixxm =7; iyym =8; izzm =9; ixym =10; ixzm =11; iyzm =12
        ivari=12
    else if ( cineli ) then
!       Pour VMIS_CINE_LINE
!           'XCINXX', 'XCINYY', 'XCINZZ', 'XCINXY', 'XCINXZ', 'XCINYZ',
!           'INDIPLAS', 'EPSPEQ'
        icels=0; icelu=0; iepsq=8; iplas=7; idiss=0; iwthe=0
        ixxm =1; iyym =2; izzm =3; ixym =4; ixzm =5; iyzm =6
        ivari=8
    else
        call utmess('F', 'ALGORITH4_50', sk=compor(1))
        icels=0; icelu=0; iepsq=0; iplas=0; idiss=0; iwthe=0
        ixxm =0; iyym =0; izzm =0; ixym =0; ixzm =0; iyzm =0
        ivari=0
    endif
    ASSERT( typmod(1).eq.'C_PLAN' )
    ASSERT( 2*ndim.eq.4 )
!   Initialisations
    ndimsi = 2*ndim
    iret=0
!
!   mise au format des contraintes de rappel
    pm    = vim(iepsq)
    pp    = vim(iepsq)
    plast = vim(iplas)
!   Cinématique
    xm(1) = vim(ixxm)
    xm(2) = vim(iyym)
    xm(3) = vim(izzm)
    xm(4) = vim(ixym)*sqrt(2.0)
    dp    = 0.0
!
    sgels = 0.0
    epelu = 0.0
!   Lecture des caractéristiques élastiques du matériau (temps- et +)
    nomres(1)='E'; nomres(2)='NU'
    call rcvalb(fami, kpg, ksp, '-', imate, ' ', 'ELAS', 0, ' ', [0.d0],&
                2, nomres, valres, icodre, 2)
    em      = valres(1)
    num     = valres(2)
    deuxmum = em/(1.0+num)
    troiskm = em/(1.0-2.0*num)
!
    call rcvalb(fami, kpg, ksp, '+', imate, ' ', 'ELAS', 0, ' ', [0.d0],&
                2, nomres, valres, icodre, 2)
    ep      = valres(1)
    nup     = valres(2)
    deuxmup = ep/(1.0+nup)
    troiskp = ep/(1.0-2.0*nup)
!
    call verift(fami, kpg, ksp, 'T', imate, epsth_=epsthe)
!
!   Lecture des caractéristiques d'écrouissage
    dsdem = 0.0
    if ( cinegc ) then
        nomres(1) = 'D_SIGM_EPSI'; nomres(2) = 'SY'
        nomres(3) = 'SIGM_LIM';    nomres(4) = 'EPSI_LIM'
        call rcvalb(fami, kpg, ksp, '-', imate, ' ', 'ECRO_LINE', 0, ' ', [0.d0],&
                    4, nomres, valres, icodre, 1)
!       vérification que SIGM_LIM, EPSI_LIM sont présents
        if (icodre(3)+icodre(4) .ne. 0) then
            valkm(1)='VMIS_CINE_GC'
            valkm(2)=nomres(3)
            valkm(3)=nomres(4)
            call utmess('F', 'COMPOR1_76', nk=3, valk=valkm)
        endif
        !
        dsdem = valres(1)
        sgels = valres(3)
        epelu = valres(4)
    else  if ( cineli ) then
        nomres(1) = 'D_SIGM_EPSI'; nomres(2) = 'SY'
        call rcvalb(fami, kpg, ksp, '-', imate, ' ', 'ECRO_LINE', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 1)
        !
        dsdem = valres(1)
    endif
    if (dsdem .le. 0.0) then
        valrm(1) = dsdem
        valrm(2) = em
        call utmess('F', 'COMPOR1_53', nr=2, valr=valrm)
    endif
    if ((em-dsdem) .lt. r8miem()) then
        valrm(1) = dsdem
        valrm(2) = em
        call utmess('F', 'COMPOR1_54', nr=2, valr=valrm)
    endif
    !
    nomres(1) = 'D_SIGM_EPSI'; nomres(2) = 'SY'
    call rcvalb(fami, kpg, ksp, '+', imate, ' ', 'ECRO_LINE', 0, ' ', [0.d0],&
                2, nomres, valres, icodre, 1)
    dsdep = valres(1)
    sigyp = valres(2)
    if (dsdep .le. 0.0) then
        valrm(1) = dsdep
        valrm(2) = ep
        call utmess('F', 'COMPOR1_53', nr=2, valr=valrm)
    endif
    if ((ep-dsdep) .lt. r8miem()) then
        valrm(1) = dsdep
        valrm(2) = ep
        call utmess('F', 'COMPOR1_54', nr=2, valr=valrm)
    endif
!
!   On code en dur ==> rprim = 0.0
    pragm = 2.0*dsdem/(1.0-dsdem/em)/3.0
    pragp = 2.0*dsdep/(1.0-dsdep/ep)/3.0
!   Dans le cas d'un écrouissage cinématique ==> rprim = 0.0
!   On garde rprim dans la suite pour être similaire à NMECMI
!   rprim = dsdep*ep/(ep-dsdep)-1.50*pragp
    rprim = 0.0
    rpm = rprim*pm + sigyp
!
!   CALCUL DE DEPSMO ET DEPSDV
    epsicplan(:) = epsm(1:ndimsi) + deps(1:ndimsi)
    deps(3)      = -nup/(1.0-nup)*(deps(1)+deps(2)) +(1.0+nup)/(1.0-nup)*epsthe
    epsicplan(3) = -nup/(1.0-nup)*(epsicplan(1)+epsicplan(2))
    depsmo = 0.0
    epsmo  = 0.0
    do kk = 1, 3
        depsth(kk) = deps(kk) - epsthe
        depsmo = depsmo + depsth(kk)
        epsmo  = epsmo  + epsicplan(kk)
    enddo
    depsmo = depsmo/3.0
    epsmo  =  epsmo/3.0
    do kk = 4, ndimsi
        depsth(kk) = deps(kk)
    enddo
    epsielu = 0.0
    do kk = 1, ndimsi
        depsdv(kk) = depsth(kk) - depsmo*kron(kk)
        epsielu    = epsielu + (epsicplan(kk) - epsmo*kron(kk))**2
    enddo
    epsielu = sqrt(2.0*epsielu/3.0)

!     write(*,*) 'JLF ', epsicplan(1:ndimsi) , epsmo, epsielu

!
!   CALCUL DE SIGMP
    sigmmo = 0.0
    do kk = 1, 3
        sigmmo = sigmmo + sigm(kk)
    enddo
    sigmmo = sigmmo/3.0
    do kk = 1, ndimsi
        sigmp(kk)=deuxmup/deuxmum*(sigm(kk)-sigmmo*kron(kk)) + troiskp*sigmmo*kron(kk)/troiskm
    enddo
!
!   CALCUL DE SIGMMO, SIGMDV, SIGEL, SIELEQ ET SEUIL :
    sigmmo = 0.0
    do kk = 1, 3
        sigmmo = sigmmo + sigmp(kk)
    enddo
    sigmmo = sigmmo/3.0
    sieleq = 0.0
    do kk = 1, ndimsi
        sigmdv(kk) = sigmp(kk) - sigmmo*kron(kk)
        xm(kk)     = xm(kk)*pragp/pragm
        sigel(kk)  = sigmdv(kk)+deuxmup*depsdv(kk)-xm(kk)
        sieleq     = sieleq + sigel(kk)**2
    enddo
    sieleq  = sqrt(1.50*sieleq)
    sigmels = 0.0
    seuil   = sieleq - rpm
    hp=1.0
    gp=1.0
!
!   CALCUL DE SIGP,SIGPDV,VIP,DP,RP:
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
!       CALCUL DE DP (ET DX SI C_PLAN) :
        if (seuil .le. 0.0) then
            plast = 0.
            dp    = 0.0
            rp    = rpm
        else
            plast = 1.0
            prec = abs(crit(3))
            niter = abs(nint(crit(1)))
            precr = prec * sigyp
!           CALCUL DE L'APPROXIMATION : DP SANS CONTRAINTE PLANE
            dp0 = sieleq - sigyp - rprim*pm
            dp0 = dp0/(rprim+1.50*(deuxmup+pragp))
            xap = dp0
            call zerofr(0, 'DEKKER', critere, 0.d0, xap, precr, niter, dp, iret, ibid)
            if (iret .eq. 1) goto 999
            rp = sigyp + rprim*(pm+dp)
        endif
        pp = pm + dp
        gp = 1.0+1.50*pragp*dp/rp
        hp = gp+1.50*deuxmup*dp/rp
        plasti=(plast.ge.0.50)
!
!       CALCUL DE SIGP :
        if ( plasti ) then
            hsg = hp/gp
            dx  = (hsg-1.0)*sigel(3)
            dx  = dx/(deuxmup/1.5 + troiskp*hsg/3.0)
            depsmo    = depsmo    + dx/3.0
            depsdv(1) = depsdv(1) - dx/3.0
            depsdv(2) = depsdv(2) - dx/3.0
            depsdv(3) = depsdv(3) + dx*2.0/3.0
        endif
        do kk = 1, ndimsi
            sigedv(kk) = sigmdv(kk) + deuxmup*depsdv(kk)
            g1         = 1.50*pragp*dp/rp/hp
            xp(kk)     = xm(kk)*(1.0-g1)+g1*sigedv(kk)
            sigpdv(kk) = sigedv(kk)*gp/hp+xm(kk)*1.50*deuxmup*dp/rp/hp
            sigp(kk)   = sigpdv(kk) + (sigmmo + troiskp*depsmo)*kron(kk)
            sigmels    = sigmels + sigpdv(kk)**2
        enddo
        sigmels = sqrt(1.50*sigmels)
    endif
!
!   CALCUL DE DSIDEP(6,6) :
    if (option(1:14).eq.'RIGI_MECA_TANG' .or. option(1:9).eq.'FULL_MECA') then
        plasti=(plast.ge.0.50)
        if (option(1:14) .eq. 'RIGI_MECA_TANG') then
!           OPTION='RIGI_MECA_TANG' => SIGMA(T)
            do kk = 1, ndimsi
                sigdv(kk) = sigmdv(kk) - xm(kk)
            enddo
            rp = rpm
        else
!           OPTION='FULL_MECA' => SIGMA(T+DT)
            do kk = 1, ndimsi
                sigdv(kk) = sigpdv(kk) - xp(kk)
            enddo
        endif
!
        dsidep(:,:) = 0.0
!
!       Partie plastique
        sigeps = 0.0
        do kk = 1, ndimsi
            sigeps = sigeps + sigdv(kk)*depsdv(kk)
        enddo
        if (plasti .and. sigeps .ge. 0.0) then
            cc=-(1.5*deuxmup/rp)**2/(1.5*(deuxmup+pragp)+rprim)*(1.0-dp*rprim/rp)/hp
            do kk = 1, ndimsi
                do ll = 1, ndimsi
                    dsidep(kk,ll) = cc*sigdv(kk)*sigdv(ll)
                enddo
            enddo
        endif
!
!       Partie élastique
        do kk = 1, 3
            do ll = 1, 3
                dsidep(kk,ll)=dsidep(kk,ll) + troiskp/3.0 - deuxmup*gp/hp/3.0
            enddo
        enddo
        do kk = 1, ndimsi
            dsidep(kk,kk) = dsidep(kk,kk) + deuxmup*gp/hp
        enddo
!
!       Correction pour les contraintes planes
        cykk: do kk = 1, ndimsi
            if (kk .eq. 3) cycle cykk
            cyll: do ll = 1, ndimsi
                if (ll .eq. 3) cycle cyll
                dsidep(kk,ll)=dsidep(kk,ll) - dsidep(kk,3)*dsidep(3,ll)/dsidep(3,3)
            enddo cyll
        enddo cykk
    endif
!
    if (option(1:9).ne.'RIGI_MECA') then
        if (crit(10) .gt. 0.0) then
            call radial(ndimsi, sigm, sigp, vim(iplas), plast, 1, vim(ixxm), vip(ixxm), radi)
            if (radi .gt. crit(10)) then
                iret=2
            endif
        endif
    endif
!
!   Mise à jour des variables internes
    if ((option(1:9).eq.'RAPH_MECA').or.(option(1:9).eq.'FULL_MECA')) then
        vip(1:ivari) = vim(1:ivari)
        vip(iepsq) = pp
        vip(iplas) = plast
        vip(ixxm)  = xp(1)
        vip(iyym)  = xp(2)
        vip(izzm)  = xp(3)
        vip(ixym)  = xp(4)/sqrt(2.0)
!       Critère ELS et ELU
        if ( cinegc ) then
            vip(icels) = sigmels/sgels
            vip(icelu) = epsielu/epelu
        endif
    endif
!
999 continue

contains
!
! --------------------------------------------------------------------------------------------------
! Variables globales : évite de passer par un common !!! NE PAS LES MODIFIER !!!
!   deuxmup, troiskp, sigyp, rprim, pm, sigel(6), pragp
!
real(kind=8) function critere(xxx)
    implicit none
    real(kind=8) ::  xxx
! --------------------------------------------------------------------------------------------------
!   Fonction dont on cherche le zéro pour la plasticité de Von Mises cinématique
!
!   Variables locales
    real(kind=8) :: rpp, gp, hp, hsg, demuc, dx, fp
! --------------------------------------------------------------------------------------------------
    rpp   = sigyp + rprim*(pm+xxx)
    gp    = 1.0+1.5*pragp*xxx/rpp
    hp    = gp+1.5*deuxmup*xxx/rpp
    hsg   = hp/gp
    demuc = deuxmup + pragp
!
    dx = (hsg-1.0)*sigel(3)
    dx = dx/(deuxmup/1.5 + troiskp*hsg/3.0 )
!
    fp= (sigel(1)-deuxmup*dx/3.0)**2 + (sigel(2)-deuxmup*dx/3.0)**2 + &
        (sigel(3)+2.0*deuxmup*dx/3.0)**2 + sigel(4)**2
!
    critere= 1.5*demuc*xxx - sqrt(1.50*fp) + rpp
!
end function

end subroutine
