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

subroutine nmhuj(fami, kpg, ksp, typmod, imat,&
                 carcri, angmas, epsd,&
                 deps, sigd, vind, opt, sigf,&
                 vinf, dsde, iret)
    implicit none
!  INTEGRATION DE LA LOI DE COMPORTEMENT ELASTO PLASTIQUE DE HUJEUX
!  AVEC    . 50 VARIABLES INTERNES
!          . 4 FONCTIONS SEUIL ELASTIQUE DEDOUBLEES AVEC CYCLIQUE
!
!  INTEGRATION DES CONTRAINTES           = SIG(T+DT)
!  INTEGRATION DES VARIABLES INTERNES    = VIN(T+DT)
!  ET CALCUL DU JACOBIEN ASSOCIE         = DS/DE(T+DT) OU DS/DE(T)
!  ================================================================
!  IN      FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!          KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
!          TYPMOD  TYPE DE MODELISATION
!          IMAT    ADRESSE DU MATERIAU CODE
!          CRIT    CRITERES  LOCAUX
!                  CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
!                            (ITER_INTE_MAXI == ITECREL)
!                  CRIT(2) = TYPE DE JACOBIEN A T+DT
!                            (TYPE_MATR_COMP == MACOMP)
!                            0 = EN VITESSE     > SYMETRIQUE
!                            1 = EN INCREMENTAL > NON-SYMETRIQUE
!                  CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
!                            (RESI_INTE_RELA == RESCREL)
!                  CRIT(5) = NOMBRE D'INCREMENTS POUR LE
!                            REDECOUPAGE LOCAL DU PAS DE TEMPS
!                            (RESI_INTE_PAS == ITEDEC )
!                            0 = PAS DE REDECOUPAGE
!                            N = NOMBRE DE PALIERS
!          ANGMAS  LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM),
!                    + UN REEL QUI VAUT 0 SI NAUTIQUIES OU 2 SI EULER
!                    + LES 3 ANGLES D'EULER
!          EPSD    DEFORMATION TOTALE A T
!          DEPS    INCREMENT DE DEFORMATION TOTALE
!          SIGD    CONTRAINTE A T
!          VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
!          OPT     OPTION DE CALCUL A FAIRE
!                          'RIGI_MECA_TANG'> DSDE(T)
!                          'FULL_MECA'     > DSDE(T+DT) , SIG(T+DT)
!                          'RAPH_MECA'     > SIG(T+DT)
!  OUT     SIGF    CONTRAINTE A T+DT
!          VINF    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
!          DSDE    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
!          IRET    CODE RETOUR DE  L'INTEGRATION DE LA LOI CJS
!                         IRET=0 => PAS DE PROBLEME
!                         IRET=1 => ECHEC
!  ----------------------------------------------------------------
!  INFO    MATERD        (*,1) = CARACTERISTIQUES ELASTIQUES A T
!                        (*,2) = CARACTERISTIQUES PLASTIQUES A T
!          MATERF        (*,1) = CARACTERISTIQUES ELASTIQUES A T+DT
!                        (*,2) = CARACTERISTIQUES PLASTIQUES A T+DT
!          NDT             NB DE COMPOSANTE TOTALES DES TENSEURS
!                                  = 6  3D
!                                  = 4  AXIS  C_PLAN  D_PLAN
!                                  = 1  1D
!          NDI             NB DE COMPOSANTE DIRECTES DES TENSEURS
!          NVI             NB DE VARIABLES INTERNES
!  ----------------------------------------------------------------
!  ROUTINE LC....UTILITAIRES POUR INTEGRATION LOI DE COMPORTEMENT
!  ----------------------------------------------------------------
!  ORDRE DES TENSEURS      3D      XX YY ZZ XY XZ YZ
!                          DP      XX YY ZZ XY
!                          AX      RR ZZ TT RZ
!                          1D      XX YY ZZ
!  ----------------------------------------------------------------
!  ATTENTION
!  SI OPT = 'RIGI_MECA_TANG' NE PAS TOUCHER AUX VARIABLES SIGF,VINF
!  QUI N ONT PAS DE PLACE MEMOIRE ALLOUEE
!
!  SIG EPS DEPS  ONT DEJA LEURS COMPOSANTES DE CISAILLEMENT
!  MULTIPLIES PAR RACINE DE 2 > PRISE EN COMPTE DES DOUBLES
!  PRODUITS TENSORIELS ET CONSERVATION DE LA SYMETRIE
!
!  ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterc/r8vide.h"
#include "asterfort/hujcrd.h"
#include "asterfort/hujcri.h"
#include "asterfort/hujcic.h"
#include "asterfort/hujcdc.h"
#include "asterfort/hujdp.h"
#include "asterfort/hujmat.h"
#include "asterfort/hujori.h"
#include "asterfort/hujpre.h"
#include "asterfort/hujprj.h"
#include "asterfort/hujres.h"
#include "asterfort/hujtel.h"
#include "asterfort/hujtid.h"
#include "asterfort/lceqve.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lcsovn.h"
#include "asterfort/lcinma.h"
#include "asterfort/mgauss.h"
#include "asterfort/utmess.h"
#include "asterfort/trace.h"
#include "asterfort/get_varc.h"
    integer      :: imat, ndt, ndi, nvi, iret, iret1, kpg, ksp
    integer      :: i, inc, incmax, ndtt, limsup
    real(kind=8) :: carcri(*), vind(50), vinf(50), vind0(50)
    real(kind=8) :: epsd(6), deps(6), deps0(6)
    real(kind=8) :: sigd(6), sigf(6), dsde(6, 6), seuil
    real(kind=8) :: piso, depsr(6), depsq(6), tin(3)
    real(kind=8) :: d, q, m, phi, b, degr, angmas(3)
    real(kind=8) :: pc0, sigd0(6), hill, dsig(6)
    character(len=7)  :: etatd, etatf
    character(len=8)  :: mod, typmod(*)
    character(len=16) :: opt
    character(len=*)  :: fami
    real(kind=8) :: depsth(6), alpha(3), tempm, tempf, tref
    real(kind=8) :: det, bid16(6), bid66(6, 6)
    real(kind=8) :: materf(22, 2), zero, un, deux, trois, dix
    real(kind=8) :: neps, nsig, ptrac, rtrac
    real(kind=8) :: crit, dpiso, tole
    aster_logical:: debug, conv, reorie, tract
!
    parameter     ( degr  = 0.0174532925199d0 )
!
!     ----------------------------------------------------------------
    common /tdim/   ndt, ndi
    common /meshuj/ debug
!     ----------------------------------------------------------------
    data       zero  / 0.0d0 /
    data       un    / 1.0d0 /
    data       deux  / 2.0d0 /
    data       trois / 3.0d0 /
    data       dix   / 10.d0 /
! Marc Kham, 31/01/2019: test sur Aratozawa montre que 20%
!                        donne de bons resultats
!                        (a 20%, le temps CPU et la solution se degradent)
    data       tole  / 0.1d0 /
!
    iret  = 0
! --- DEBUG = .TRUE. : MODE AFFICHAGE ENRICHI
    debug = .false.
    tract = .false.
!
    if (debug) then
       write(6,*)
       write(6,'(A)') '!!!!(@_@)!!!!                        !!!!(@_@)!!!!'
       write(6,'(A)') '!!!!(@_@)!!!!    MODE DEBUG ACTIF    !!!!(@_@)!!!!'
       write(6,'(A)') '!!!!(@_@)!!!!                        !!!!(@_@)!!!!'
    endif
!
    mod = typmod(1)
!
! - Get temperatures
!
    call get_varc(fami , kpg  , ksp , 'T', tempm, tempf, tref)
!
! ---> RECUPERATION COEF DE LA LOI HUJEUX
!      (INDEPENDANTS DE LA TEMPERATURE)
!      NB DE CMP DIRECTES/CISAILLEMENT
!      NB VARIABLES INTERNES
    call hujmat(fami, kpg, ksp, mod, imat,&
                tempf, materf, ndt, ndi, nvi)
!
    ptrac = materf(21,2)
    rtrac = abs(1.d-6*materf(8,2))
!
! --- REORIENTATION DES PLANS DE GLISSEMENT SUR LES AXES DU
!     REPERE LOCAL DONNE PAR LES ANGLES NAUTIQUES (ANGMAS)
    if (angmas(1) .eq. r8vide()) then
        call utmess('F', 'ALGORITH8_20')
    endif
!
    reorie =(angmas(1).ne.zero) .or. (angmas(2).ne.zero) .or. &
            (angmas(3).ne.zero)
!
    call hujori('LOCAL', 1, reorie, angmas, sigd, bid66)
    call hujori('LOCAL', 1, reorie, angmas, epsd, bid66)
    call hujori('LOCAL', 1, reorie, angmas, deps, bid66)
!
! --- ON TRAVAILLE TOUJOURS AVEC UN TENSEUR CONTRAINTES
!     DEFINI EN 3D
!
    ndtt = 6
    if (ndt .lt. 6) then
       ndtt = 4
       ndt  = 6
    endif
!
!     CALCUL DE DEPSTH ET EPSDTH
!     --------------------------
! ---> COEF DE DILATATION LE MEME A TPLUS ET TMOINS
    if (materf(17,1) .eq. un) then
!
        if ((isnan(tempm) .or. isnan(tref)) .and.&
           materf(3,1).ne.zero) then
            call utmess('F', 'CALCULEL_15')
        endif
!
        alpha(1) = materf(3,1)
        alpha(2) = materf(3,1)
        alpha(3) = materf(3,1)
!
    else if (materf(17,1).eq.deux) then
!
        alpha(1) = materf(10,1)
        alpha(2) = materf(11,1)
        alpha(3) = materf(12,1)
        if ( (isnan(tempm).or.isnan(tref)) .and. &
             (alpha(1).ne.zero .or. alpha(2).ne.zero .or. &
             alpha(3).ne.zero) ) then
            call utmess('F', 'CALCULEL_15')
        endif
!
    else
        ASSERT(ASTER_FALSE)
    endif
!
    if (isnan(tempm) .or. isnan(tempf) .or. isnan(tref)) then
       do i = 1, ndi
         depsth(i) = deps(i)
       enddo
    else
       do i = 1, ndi
         depsth(i) = deps(i) - &
         alpha(i)*(tempf-tref) + alpha(i)*(tempm-tref)
       enddo
    endif
!
    do i = ndi+1, ndt
        depsth(i) = deps(i)
    enddo
!
    if (ndtt .lt. 6) then
       do i = ndtt+1, 6
         depsth(i) = zero
         sigd(i)   = zero
       enddo
    endif
!
! ---> INITIALISATION SEUIL DEVIATOIRE SI NUL
!
    do i = 1, ndi
        if (vind(i) .eq. zero) then
!
            if (materf(13, 2) .eq. zero) then
                vind(i) = 1.d-3
            else
                vind(i) = materf(13,2)
            endif
!
            call hujcrd(i, materf, sigd, vind, seuil, iret)
            if (iret .ne. 0) then
                goto 999
            endif
!
! --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
!     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
!     APPROPRIEE
!
            if (seuil .gt. zero) then
                call hujprj(i, sigd, tin, piso, q)
                piso = piso - ptrac
                b    = materf(4,2)
                phi  = materf(5,2)
                m    = sin(degr*phi)
                pc0  = materf(7,2)
                vind(i)    = -q/(m*piso*(un-b*log(piso/pc0)))
                vind(23+i) = un
            endif
!
        endif
    enddo
!
! ---> INITIALISATION SEUIL ISOTROPE SI NUL
    if (vind(4) .eq. zero) then
        if (materf(14, 2) .eq. zero) then
            vind(4) = 1.d-3
        else
            vind(4) = materf(14,2)
        endif
!
        call hujcri(materf, sigd, vind, seuil)
!
! --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
!     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
!     APPROPRIEE
!
        if (seuil .gt. zero) then
            piso    = trace(3,sigd)/trois
            d       = materf(3,2)
            pc0     = materf(7,2)
            vind(4) = piso/(d*pc0)
            if (vind(4) .gt. 1.d0) then
                call utmess('F', 'COMPOR1_83')
            endif
            vind(27)= un
        endif
!
    endif
!
! ---> INITIALISATION SEUIL CYCLIQUE SI NUL
    do i = 1, ndi
        if (vind(4+i) .eq. zero) then
            if (materf(18, 2) .eq. zero) then
                vind(4+i) = 1.d-3
            else
                vind(4+i) = materf(18,2)
            endif
        endif
    enddo
!
    if (vind(8) .eq. zero) then
        if (materf(19, 2) .eq. zero) then
            vind(8) = 1.d-3
        else
            vind(8) = materf(19,2)
        endif
    endif
!
!ONTROLE DES INDICATEURS DE PLASTICITE
    do i = 1, 4
        if (abs(vind(27+i)-un) .lt. r8prem()) vind(23+i)=-un
    enddo
!
    if (opt(1:9) .ne. 'RIGI_MECA') call lceqvn(50, vind, vinf)
!
! ---> ETAT ELASTIQUE OU PLASTIQUE A T
    if (( (vind(24) .eq. zero) .or. &
          (vind(24) .eq. -un .and. vind(28) .eq. zero) ) .and.&
        ( (vind(25) .eq. zero) .or. &
          (vind(25) .eq. -un .and. vind(29) .eq. zero) ) .and.&
        ( (vind(26) .eq. zero) .or. &
          (vind(26) .eq. -un .and. vind(30) .eq. zero) ) .and.&
        ( (vind(27) .eq. zero) .or. &
          (vind(27) .eq. -un .and. vind(31) .eq. zero) )) then
        etatd = 'ELASTIC'
    else
        etatd = 'PLASTIC'
    endif
!
! -------------------------------------------------------------
! OPTIONS 'FULL_MECA' ET 'RAPH_MECA' = CALCUL DE SIG(T+DT)
! -------------------------------------------------------------
    conv =.true.
    if (opt(1:9) .eq. 'RAPH_MECA' .or. opt(1:9) .eq. 'FULL_MECA') then
!
        if (debug) write(6,*) ' * DEPS =',(depsth(i),i=1,3)
!
        do i = 1, 3
            call hujprj(i, sigd, tin, piso, q)
            if (abs(piso+deux*rtrac-ptrac) .lt. r8prem()) &
              tract = .true.
        enddo
!
! INTEGRATION ELASTIQUE SUR DT
        do i = 1, ndt
            depsq(i) = zero
        enddo
!
! -----------------------------------------------
! ---> INCREMENT TOTAL DE DEFORMATION A APPLIQUER
! -----------------------------------------------
! ENREGISTREMENT DE L'ETAT DE CONTRAINTES A T
        call lceqve(sigd, sigd0)
!
! ENREGISTREMENT DE L'INCREMENT TOTAL DEPS0
        call lceqve(depsth, deps0)
!
! INITIALISATION DES DEFORMATIONS RESTANTES
        call lceqve(depsth, depsq)
        call lceqvn(nvi, vind, vind0)
!
! INITIALISATION DU COMPTEUR D'ITERATIONS LOCALES
!        vind(35) = zero
!
! -----------------------------------------------------
! ---> PREDICTION VIA TENSEUR ELASTIQUE DES CONTRAINTES
! -----------------------------------------------------
        inc    = 0
        incmax = 1
        limsup = int(max(20.d0,abs(carcri(1))))
!
100     continue
!
        inc = inc + 1
        call lceqve(depsq, depsr)
        call hujpre(fami, kpg, ksp, etatd, mod,&
                    imat, materf, depsr, sigd,&
                    sigf, vind0, iret)
!
        if (iret.eq.1) then
           if (debug) &
           write (6, '(A)' ) &
           '!!!@_@!!! NMHUJ :: ARRET DANS HUJPRE !!!@_@!!!'
           goto 999
        endif
!
! ----------------------------------------------------
! ---> CONTROLE DE L EVOLUTION DE LA PRESSION ISOTROPE
! ----------------------------------------------------
        iret1 =0
        call hujdp(mod, depsr, sigd, sigf, materf,&
                   vind, incmax, iret1)

        if (iret1.eq.1) then
           if (debug) &
           write (6, '(A)' ) &
  '!!!@_@!!! NMHUJ :: ARRET DANS HUJDP :: PAS DE RESUBDIVISION !!!@_@!!!'
!           goto 999
        endif
!
! --- ON LIMITE LE REDECOUPAGE LOCAL A MAX(20,ITER_INTE_MAXI)
        if (incmax .ge. limsup) then
            incmax = limsup
        else if (incmax.le.1) then
            incmax =1
        endif
!
        if (inc .eq. 1 .and. incmax .gt. 1) then
            do i = 1, ndt
                depsq(i)=deps0(i) /incmax
                depsr(i)=deps0(i) /incmax
            enddo
            call hujpre(fami, kpg, ksp, etatd, mod,&
                        imat, materf, depsr, sigd,&
                        sigf, vind0, iret)
        endif
!
! ---------------------------------------------
! CALCUL DE L'ETAT DE CONTRAINTES CORRESPONDANT
! ---------------------------------------------
        if (debug) write(6,*)&
        '!!!@_@!!! NMHUJ -- VINF =',(vinf(i),i=24,31),' !!!@_@!!!'
!
        call hujres(fami, kpg, ksp, mod, carcri,&
                    materf, imat, nvi, depsr, sigd,&
                    vind, sigf, vinf, iret, etatf)
        if (iret .eq. 1) goto 999
!
! -------------------------------------------
! - CONTROLE DES DEFORMATIONS DEJA APPLIQUEES
! -------------------------------------------
        if (inc .lt. incmax) then
            conv =.false.
        else
            conv =.true.
        endif
!
        if (.not.conv) then
            call lceqve(sigf, sigd)
            call lceqvn(nvi, vinf, vind)
            goto 100
        endif
!
! --- CALCUL DU CRITERE DE HILL: DSIG*DEPS
        hill = zero
        nsig = zero
        neps = zero
        do i = 1, ndt
            dsig(i) = sigf(i) - sigd0(i)
            hill = hill + dsig(i)*deps0(i)
            nsig = nsig + dsig(i)**deux
            neps = neps + deps0(i)**deux
        enddo
!
! --- NORMALISATION DU CRITERE : VARIE ENTRE -1 ET 1
        if (neps.gt.r8prem() .and. nsig.gt.r8prem()) then
            vinf(32) = hill/sqrt(neps*nsig)
        else
            vinf(32) = zero
        endif
!
    endif
!af 07/05/07 fin <IF RAPH_MECA et FULL_MECA>
!
!       ----------------------------------------------------------------
!       OPTIONS 'FULL_MECA' ET 'RIGI_MECA_TANG' = CALCUL DE DSDE
!       ----------------------------------------------------------------
!       CALCUL ELASTIQUE ET EVALUATION DE DSDE A (T)
!       POUR 'RIGI_MECA_TANG' ET POUR 'FULL_MECA'
!       ----------------------------------------------------------------
    if (opt .eq. 'RIGI_MECA_TANG') then
!
        call lcinma(zero, dsde)
!
! REMARQUE: CALCUL DE DSDE A T AVEC MATERF CAR PARAMETRES HUJEUX
! --------  INDEPENDANTS DE LA TEMPERATURE
!
! ---> CALCUL MATRICE DE RIGIDITE ELASTIQUE
        if (etatd .eq. 'ELASTIC') then
            call hujtel(mod, materf, sigd, dsde)
        endif
!
! ---> CALCUL MATRICE TANGENTE DU PROBLEME CONTINU
        if (etatd .eq. 'PLASTIC') then
            call hujtid(fami, kpg, ksp, mod, imat,&
                        sigd, vind, dsde, iret)
            if (iret .eq. 1) goto 999
        endif
!
        call hujori('GLOBA', 2, reorie, angmas, bid16, dsde)
!
    else if (opt .eq. 'FULL_MECA') then
!
        call lcinma(zero, dsde)
!
! ---> CALCUL MATRICE DE RIGIDITE ELASTIQUE
        if (etatf .eq. 'ELASTIC') then
            call hujtel(mod, materf, sigf, dsde)
        endif
!
! ---> CALCUL MATRICE TANGENTE DU PROBLEME CONTINU
        if (etatf .eq. 'PLASTIC') then
            call hujtid(fami, kpg, ksp, mod, imat,&
                        sigf, vinf, dsde, iret)
            if (iret.eq.1) goto 999
        endif
!
    else if (opt .eq. 'FULL_MECA_ELAS') then
!
        call lcinma(zero, dsde)
        call hujtel(mod, materf, sigf, dsde)
!
    else if (opt .eq. 'RIGI_MECA_ELAS') then
!
        call lcinma(zero, dsde)
        call hujtel(mod, materf, sigd, dsde)
        call hujori('GLOBA', 2, reorie, angmas, bid16, dsde)
!
    endif
! fin <IF RIGI_MECA_TANG>
!
! ---> CALCUL DETERMINANT DE LA MATRICE TANGENTE + INDICATEUR
! --- RELIE AUX MECANISMES ACTIFS
    if (opt(1:9) .ne. 'RIGI_MECA') then
!
        call hujori('GLOBA', 2, reorie, angmas, bid16,&
                    dsde)
!
        if (opt .eq. 'FULL_MECA') then
            call mgauss('NCSD', dsde, sigd, 6, 6,&
                        1, det, iret)
            if (iret .eq. 1) then
                vinf(33) = un
                iret     = 0
            else
                vinf(33) = det
            endif
        endif
!
!        vinf(34) = zero
!         do i = 1, 8
!             if (abs(vinf(23+i)-un) .lt. r8prem()) then
!                 if (i .eq. 1) vinf(34)=vinf(34)+dix**zero
!                 if (i .eq. 2) vinf(34)=vinf(34)+dix**un
!                 if (i .eq. 3) vinf(34)=vinf(34)+dix**deux
!                 if (i .eq. 4) vinf(34)=vinf(34)+dix**3.d0
!                 if (i .eq. 5) vinf(34)=vinf(34)+dix**4.d0
!                 if (i .eq. 6) vinf(34)=vinf(34)+dix**5.d0
!                 if (i .eq. 7) vinf(34)=vinf(34)+dix**6.d0
!                 if (i .eq. 8) vinf(34)=vinf(34)+dix**7.d0
!             endif
!         enddo
!
    endif
! --- ON RENVOIE LA VALEUR ADEQUATE DE NDT
!     POUR MODELISATION D_PLAN
    if (ndtt .eq. 4) ndt = 4
!
    if (opt .eq. 'RAPH_MECA' .or. opt(1:9) .eq. 'FULL_MECA') &
       call hujori('GLOBA', 1, reorie, angmas, sigf, bid66)
!
999  continue
!
    if (opt(1:9) .eq. 'RAPH_MECA' .or. opt(1:9) .eq. 'FULL_MECA' &
        .or. opt(1:14) .eq. 'RIGI_MECA_ELAS') then
        if (iret .eq. 1) then
            if (.not.tract) then
                call lcinma(zero, dsde)
                call hujtid(fami, kpg, ksp, mod, imat,&
                            sigd, vind, dsde, iret1)
                if (iret1 .eq. 1) then
                   call lcinma(zero, dsde)
                   call hujtel(mod, materf, sigd, dsde)
                endif
! debut ---new dvp 23/01/2019---
                call lcprmv(dsde, deps0, dsig)
!
! on limite la variation de dsig a 2% par rapport a piso
                piso =trace(3,sigd0)
                dpiso=trace(3,dsig)
                if (piso.lt.-100. .and. abs(dpiso/piso).le.tole) then
                   det=1.
                elseif (piso.lt.-100.) then
                   det=tole*abs(piso/dpiso)
                else
                   det=0.
                endif
                call lcprsv(det, dsig, dsig)

                call lcsovn(6, sigd0, dsig, sigf)
! semble moins performant que + haut:
!                 call lceqve(sigd0, sigf)
!
! y-a-t-il traction?
                conv = .true.
                do i = 1, 3
                  call hujprj(i, sigf, tin, piso, q)
                  if (abs(piso+deux*rtrac-ptrac) .lt. r8prem()) &
                    conv = .false.
                enddo
!
                if (.not.conv) then
                   do i = 1, 3
                    sigf(i)  = -deux*rtrac+ptrac
                    sigf(i+3)= zero
                   enddo
                   call lcinma(zero, dsde)
                   call hujtel(mod, materf, sigd, dsde)
                endif
!
                call lceqvn(50, vind0, vinf)
! fin   ---new dvp 23/01/2019---
                if (debug) then
                    write(6,'(A)') ' ----------- FIN NMHUJ -----------------'
                    write(6,*) ' * DEPS =',(deps0(i),i=1,ndt)
                    write(6,*) ' * SIGD =',(sigd0(i),i=1,ndt)
                    write(6,*) ' * VIND =',(vind0(i),i=1,50)
                    write(6,*) ' * SIGF =',(sigf(i),i=1,ndt)
                    write(6,*) ' * VINF =',(vinf(i),i=1,50)
                    write(6,'(A)')' ----------------------------------------'
                endif
            else
!
                call lcinma(zero, dsde)
                call hujtel(mod, materf, sigd, dsde)
                do i = 1, 3
                    sigf(i) = -deux*rtrac+ptrac
                    sigf(i+3) = zero
                enddo
                call lceqvn(50, vind0, vinf)
                iret = 0
            endif
        endif
        call lceqve(sigd0, sigd)
        call lceqve(deps0, deps)
        call lceqvn(50, vind0, vind)
! debut ---new dvp 23/01/2019---
! sauvegarde d'une estimation de l'erreur cumulee
! L'erreur est mesuree sur F=(sigm, vari_interne)=0
!
        crit =zero
!
        if (conv) then
           det  =abs(trace(3,deps0))
           do i = 1, 8
!
! On normalise les seuils de la meme facon que dans hujjid
! i.e. par le module d'Young materf(1,1)/Pcr0
! pour assurer la coherence du controle avec RESI_INTE_RELA
              if (i.lt.4) then

                 call hujcrd(i, materf, sigf, vinf, seuil, iret)
                 if (iret .ne. 0) then
                    goto 999
                 endif
                 seuil   = seuil*det

                 if (seuil.gt.zero) then
                   bid16(i)=un
                 else
                   bid16(i)=zero
                 endif

              elseif (i.eq.4) then

                 call hujcri(materf, sigf, vinf, seuil)
                 seuil   = seuil/materf(1,1)*abs(materf(7,2))

                 if (seuil.gt.zero) then
                   bid16(4)=un
                 else
                   bid16(4)=zero
                 endif

              elseif (i.lt.8 .and. bid16(i-4).eq.zero) then

                 call hujcdc(i-4, materf, sigf, vinf, seuil)
                 seuil = seuil*det

              elseif (bid16(4).eq.zero) then

                 call hujcic(materf, sigf, vinf, seuil)
                 seuil = seuil/materf(1,1)*abs(materf(7,2))

              endif

              crit = max(seuil,crit)
!
           enddo
        endif
!
        vinf(34)=crit
        vinf(35)=zero
! fin   ---new dvp 23/01/2019---
    endif
!
end subroutine
