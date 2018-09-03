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

subroutine hujmid(mod, crit, mater, nvi, deps,&
                  sigd, sigf, vind, vinf, noconv,&
                  aredec, stopnc, negmul, iret, subd,&
                  loop, ndec0, indi, mectra)
! aslint: disable=W1501
    implicit none
! INTEGRATION PLASTIQUE (MECANISMES ISOTROPE ET DEVIATOIRE) DE HUJEUX
! IN   MOD     :  MODELISATION
!      CRIT    :  CRITERES DE CONVERGENCE
!      MATER   :  COEFFICIENTS MATERIAU A T+DT
!      NVI     :  NB DE VARIABLES INTERNES
!      DEPS    :  INCREMENTS DE DEFORMATION
!      SIGD    :  CONTRAINTE  A T
!      SIGF    :  PREDICTION ELASTIQUE OU PLASTIQUE
!      VIND    :  VARIABLES INTERNES  A T
!      AREDEC   =.TRUE.  ARRET DES DECOUPAGES
!      STOPNC   =.TRUE.  ARRET EN CAS DE NON CONVERGENCE
!      LOOP     =.TRUE.  PREDICTION PLASTIQUE DES CONTRAINTES
!               =.FALSE. PREDICTION ELASTIQUE DES CONTRAINTES
! VAR  SIGF    :  CONTRAINTE  A T+DT
!      VINF    :  VARIABLES INTERNES  A T+DT
!      NOCONV   =.TRUE.  NON CONVERGENCE
!      NEGMUL   =.TRUE.  MULTIPLICATEUR NEGATIF
!      SUBD     =.TRUE. SUBDIVISION DU A (DR/R) < CRIT
!      NDEC0   :  NOMBRE D'INCREMENTS DE SUBDIVISION LIE A SUBD
!      IRET    :  CODE RETOUR
!   -------------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/hujiid.h"
#include "asterfort/hujjid.h"
#include "asterfort/hujncv.h"
#include "asterfort/hujprj.h"
#include "asterfort/infniv.h"
#include "asterfort/iunifi.h"
#include "asterfort/lceqve.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcnrvn.h"
#include "asterfort/lcsovn.h"
#include "asterfort/mgauss.h"
    integer :: ndt, ndi, nvi, nr, nmod, iret, nbmect
    integer :: i, j, k, kk, iter, indi(7), ndec0, ndec
    integer :: nitimp, nbmeca, compt, msup(4)
    integer :: umess, ifm, niv
    integer :: essai, essmax, resi, nmax, imin
    aster_logical :: debug, noconv, aredec, stopnc, negmul(8), subd
    aster_logical :: loop, euler
!
    common    /tdim/ ndt, ndi
    common    /meshuj/ debug
!
    parameter (nmod   = 18)
    parameter (nitimp = 200)
    parameter (essmax = 10)
!
    real(kind=8) :: deps(6), i1f, deux
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: vind(*), vinf(*), lamin
    real(kind=8) :: crit(*), mater(22, 2)
    real(kind=8) :: r(nmod), drdy(nmod, nmod)
    real(kind=8) :: ddy(nmod), dy(nmod), yd(nmod), yf(nmod)
    real(kind=8) :: err, dsig(6)
    real(kind=8) :: det, zero, un, ratio, maxi
    real(kind=8) :: evol
    real(kind=8) :: rdec, tole2
!
    real(kind=8) :: relax(essmax+1)
    real(kind=8) :: erimp(nitimp, 4), pref, dev(3), pf, qf
    real(kind=8) :: ptrac, ye(nmod), tole1, rtrac
!
    real(kind=8) :: predi0(6), sigd0(6), deps0(6), vind0(50), prob(4)
    aster_logical :: arede0, stopn0, loop0, prox(4), probt, proxc(4)
    aster_logical :: tracti, cycl, negtra, bnews(3), nodef
    aster_logical :: neglam(3), mectra, ltry, modif, mtrac
!
    character(len=8) :: mod
!
    data   zero, un, deux, tole1 / 0.d0, 1.d0, 2.d0, 1.d-6/
!
! ====================================================================
! ---- PROPRIETES MATERIAU
! -------------------------
    pref = mater(8,2)
    rtrac = abs(pref*1.d-6)
    tole2 = un/(pref**2)
! ----------------------------------------------------------------
! --- INITIALISATION VECTEUR GESTION MECANISMES TRACTION: PK-DP<=0
! ----------------------------------------------------------------
    do i = 1, 3
        bnews(i) = .true.
        dev(i) = zero
    enddo
!
    mectra = .false.
    mtrac = .false.
! --------------------------------------------------
! ----  SAUVEGARDE DES GRANDEURS D ENTREE INITIALES
! --------------------------------------------------
! --- LIMITATION DU REDECOUPAGE DU A UNE EVOLUTION TROP RAPIDE
!     DES VARIABLES INTERNES RDEV, RISO OU EPSVP
    nmax = 3
!
    call lceqve(sigf, predi0)
    call lceqve(sigd, sigd0)
    call lceqve(deps, deps0)
    call lceqvn(nvi, vind, vind0)
    arede0 = aredec
    stopn0 = stopnc
    loop0 = loop
    compt = 0
    probt = .false.
    do i = 1, 4
        prox(i) = .false.
        proxc(i) = .false.
    enddo
!
 30 continue
    if (compt .gt. 5) goto 9999
    compt = compt + 1
    if (debug) write(6,*)'DEBUT --- VINF =',(vinf(i),i=24,31)
!
! --------------------------------------------------
! ---> DIMENSION DU PROBLEME:
!      NR = NDT(SIG)+ 1(EVP)+ NBMECA(R)+ NBMEC(DLAMB)
! --------------------------------------------------
!
    umess = iunifi('MESSAGE')
    call infniv(ifm, niv)
!
    noconv = .false.
    tracti = .false.
    nodef = .false.
!
    do k = 1, 4
        prob(k) = zero
    enddo
!
    ptrac = mater(21,2)
!
    nbmeca = 0
    do k = 1, 8
        if (vind(23+k) .eq. un) nbmeca = nbmeca + 1
        negmul(k) = .false.
    enddo
    nr = ndt + 1 + 2*nbmeca
!
! ----------------------------
! ---> MISE A ZERO DES DATAS
! ----------------------------
    do i = 1, nmod
        ddy(i) = zero
        dy(i) = zero
        yd(i) = zero
        yf(i) = zero
        r(i) = zero
    enddo
!
!
! --------------------------------------------------
! ---> INITIALISATION DE YD = (SIGD, VIND, ZERO)
! --------------------------------------------------
    call lceqvn(ndt, sigd, yd)
!
    yd(ndt+1) = vind(23)
!
    do k = 1, 7
        indi(k)=0
    enddo
!
    kk = 1
    do k = 1, 8
        if (vind(23+k) .eq. un) then
!
            if (k .ne. 4) then
                indi(kk) = k
                yd(ndt+1+kk) = vind(k)
                yd(ndt+1+nbmeca+kk) = zero
                kk = kk + 1
            else
                indi(nbmeca) = k
                yd(ndt+1+nbmeca) = vind(k)
                yd(ndt+1+2*nbmeca) = zero
            endif
!
        endif
    enddo
!
    if (debug) then
        write(6,*)'INDI = ',(indi(i),i=1,nbmeca)
        write(6,*)'SIGD = ',(sigd(i),i=1,ndt)
        write(6,*)'SIGF = ',(sigf(i),i=1,ndt)
        write(6,*)'DEPS = ',(deps(i),i=1,ndt)
        write(6,*)'VIND = ',(vind(i),i=24,31)
        write(6,*)'VIND = ',(vind(i),i=21,22)
        write(6,*)'VIND = ',(vind(i),i=1,8)
        write(6,*)'LOOP = ',loop
        write(6,*)
    endif
!
    i1f = (sigf(1) + sigf(2) + sigf(3))/3.d0
!
! ------------------------------------------------------------
! --- APRES CHGT DE MECANISMES AU NIVEAU DE HUJACT
!     LOOP = .TRUE. --> RECUPERE ETAT DE CONTRAINTES CONVERGE
!     COMME PREDICTEUR D'EULER
! ------------------------------------------------------------
!
    if (loop) then
        do i = 1, ndt
            dsig(i) = sigf(i) - sigd(i)
        enddo
    else
        do i = 1, ndt
            dsig(i) = zero
        enddo
    endif
!
! ------------------------------------------------------------------
! ---> INITIALISATION : DY : CALCUL DE LA SOLUTION D ESSAI INITIALE
!      (SOLUTION EXPLICITE)
! ------------------------------------------------------------------
    call hujiid(mod, mater, indi, deps, i1f,&
                yd, vind, dy, loop, dsig,&
                bnews, mtrac, iret)
!
    if (debug) write(6,*)'INDI =',(indi(i),i=1,7)
!
! -------------------------------------------
! ---> MECANISMES DE TRACTION A CONSIDERER ?
! ---> SI OUI, REDIMENSIONNEMENT DE YF
! -------------------------------------------
    nbmect = nbmeca
    do i = 1, 7
        if (indi(i) .gt. 8) then
            nr = nr + 1
            nbmect = nbmect + 1
        endif
    enddo
    if(nbmect.ne.nbmeca)mectra = .true.
! ------------------------------------
! ---> INCREMENTATION DE YF = YD + DY
! ------------------------------------
!
    call lcsovn(nr, yd, dy, yf)
    call lceqvn(nmod, yf, ye)
!
    if (iret .eq. 1) goto 9999
!
    if (debug) then
        write(6,*)'NR = ',nr
        write (ifm,'(A)') '------------------------------------------'
        write(6,*)'INDI =',(indi(i),i=1,nbmect)
        write (ifm,'(A)') '- SIXX - SIYY - SIZZ - SIXY - SIXZ - SIYZ -'//&
     &'EPSVP - R1 - R2 - R3 - R4 - DLA1 - DLA2 - DLA3 - DLA4 -'
        write (ifm,1000) '  > ESSAI :: YF=',(yf(i),i=1,nr)
!
    endif
!
! ----------------------------------------------------
! ---> RESTRICTION DES VALEURS DE SIGE A PREF**2
! ---  SINON RENVOI EN ECHEC OU LES MECA DE TRACTION
! ---  SONT DESACTIVES
! ----------------------------------------------------
    if (nbmeca .ne. nbmect) then
        do i = 1, ndi
            if (abs(ye(i)) .gt. pref**2.d0) nodef = .true.
        enddo
        if (nodef) then
            iret = 1
            goto 9999
        endif
    endif
!
!
!----------------------------------------------------------
! ---> BOUCLE SUR LES ITERATIONS DE NEWTON
!----------------------------------------------------------
    iter = 0
130 continue
!
    iter = iter + 1
    do i = 1, nmod
        r(i) = zero
        do j = 1, nmod
            drdy(i,j) = zero
        enddo
    enddo
! ---> CALCUL DU SECOND MEMBRE A T+DT : -R(DY)
!      ET CALCUL DU JACOBIEN DU SYSTEME A T+DT : DRDY(DY)
!
    call hujjid(mod, mater, indi, deps, prox,&
                proxc, yd, yf, vind, r,&
                drdy, iret)
!
! -----------------------------------------------------
! ---> CRITERE DE PROXIMITE ENTRE SURFACES DEVIATOIRES
! --- PROB = UN ---> PROXIMITE CYCLIQUE/MONOTONE
! --- PROB = DEUX ---> PROXIMITE CYCLIQUES: FILS/PERE
! -----------------------------------------------------
    do i = 1, 3
        neglam(i) = .false.
        if (prox(i)) then
            prob(i) = un
            probt = .true.
        else if (proxc(i)) then
            prob(i) = deux
            probt = .true.
        endif
    enddo
!
!
! ------------------------------------------------------------
! ---> SI ECHEC DANS LE CALCUL DE LA JACOBIENNE DR/DY
! ---  ON VERIFIE LES ETATS DE CONTRAINTES DE YF A L'ITERATION
! ---  DE CORRECTION PRECEDENTE. SI TRACTION IL Y A, ON TRAITE
! ---  LE PB APRES L'ETIQUETTE 9999
! ------------------------------------------------------------
    if (iret .eq. 1) then
        if (debug) write(6,'(A)')'HUJMID :: ERREUR DANS HUJJID'
        do i = 1, 3
            call hujprj(i, yf, dev, pf, qf)
            if (((rtrac+pf-ptrac)/abs(pref)) .ge. -r8prem()) then
                tracti = .true.
            endif
        enddo
        goto 9999
    endif
!
! ---> RESOLUTION DU SYSTEME LINEAIRE : DRDY(DY).DDY = -R(DY)
    call lceqvn(nr, r, ddy)
    call mgauss('NCVP', drdy, ddy, nmod, nr,&
                1, det, iret)
!
! ----------------------------------------------------
! ---> SI ECHEC DANS LA RESOLUTION DU SYSTEME LINEAIRE
! ---  RENVOI A L'ETIQUETTE 9999
! ----------------------------------------------------
    if (iret .eq. 1) then
        if (debug) write(6,'(A)')'HUJMID :: ERREUR DANS MGAUSS'
        goto 9999
    endif
    relax(1) = un
    essai = 1
!
! ------------------------
! ---> 2) ERREUR = RESIDU
! ------------------------
! - TEST SUR LES VALEURS MAXIMUM DU RESIDU
! SI LES VALEURS SONT TROP GRANDES(>PREF**2), ON ASSUME L ECHEC
! DE L INTEGRATION LOCALE AVEC UN RETOUR A 9999
    do i = 1, nr
        if (abs(r(i)) .gt. pref**2) then
            iret = 1
            goto 9999
        endif
    end do
    call lcnrvn(nr, r, err)
    if (debug) write(6,*)'ERREUR =',err
!
    if (iter .le. nitimp) then
        erimp(iter,1) = err
        erimp(iter,2) = relax(essai)
    endif
!
! ----------------------------------------------------------------
!     SI ON N'A PAS ATTEINT LE NB MAX D'ITERATION: RESI_INTE_MAXI
! ----------------------------------------------------------------
    if (iter .le. int(abs(crit(1)))) then
!
! -------------------------
! ----   CONVERVENCE   ----
! -------------------------
        if ((err .lt. crit(3)) .and. (iter.gt.1)) then
            goto 250
!
! ------------------------------------------------
! ----  NON CONVERVENCE : ITERATION SUIVANTE  ----
! ------------------------------------------------
        else
! ------------------------------------
! --- REDIMENSIONNEMENT DES INCONNUES
! --- SIGMA * E0, R * E0/PREF
! ------------------------------------
!
            do i = 1, ndt
                ddy(i) = ddy(i)*mater(1,1)
            enddo
            do i = 1, nbmeca
                ddy(ndt+1+i) = ddy(ndt+1+i)*mater(1,1)/ abs(mater(8,2) )
            enddo
!
! -----------------------------------
! --- MISE A JOUR DU VECTEUR SOLUTION
! -----------------------------------
            do i = 1, nr
                dy(i) = dy(i) + ddy(i)
                yf(i) = yd(i) + dy(i)
            enddo
!
            if (debug) then
!
                write(ifm,*)
                write(ifm,1001) '  $$ ITER=',iter
!        WRITE(IFM,1000) '     DDY=',(DDY(I),I=1,NR)
!        WRITE(IFM,1000) '     DY =',(DY(I),I=1,NR)
                write(ifm,1000) '     YF =',(yf(i),i=1,nr)
                write(ifm,1000) '     R  =',(r(i),i=1,nr)
!
            endif
! -----------------------------------------------------
! --- CONTROLE DE L'ETAT DE CONTRAINTE PAR RAPPORT A LA
!     LIMITE DE TRACTION A NE PAS DEPASSEE
! -----------------------------------------------------
            if ((nbmeca.ne.nbmect) .and. (nbmeca.eq.0)) then
                if (err .gt. 1d5) then
                    iret = 1
                    goto 9999
                endif
                goto 240
            else
                do i = 1, 3
                    call hujprj(i, yf, dev, pf, qf)
                    if (((pf+rtrac-ptrac)/abs(pref)) .ge. -r8prem()) then
                        do j = 1, nbmeca
                            if ((indi(j).eq.i) .or. (indi(j).eq.(i+4))) then
                                tracti = .true.
                                goto 9999
                            endif
                        enddo
                    endif
                enddo
            endif
!
240         continue
!
            goto 130
        endif
!
    else
!
! ----------------------------------------------------
! ----  NON CONVERVENCE: ITERATION MAXI ATTEINTE  ----
! ----------------------------------------------------
        if (aredec .and. stopnc) then
            call hujncv('HUJMID', nitimp, iter, ndt, nvi,&
                        umess, erimp, deps, sigd, vind)
        else
            iret = 1
            goto 9999
        endif
!
    endif
!
250 continue
!
! ---------------------------------------------------
! --- CONTROLE DES RESULTATS OBTENUS APRES RESOLUTION
!     DU SYSTEME NON LINEAIRE LOCAL
! ---------------------------------------------------
!
! -------------------------------------------------
! ---- VERIFICATION DES MULTIPLICATEURS PLASTIQUES
! -------------------------------------------------
    maxi = abs(crit(3))
    do k = 1, nbmect
        if (yf(ndt+1+nbmeca+k) .gt. maxi) maxi = yf(ndt+1+nbmeca+k)
    enddo
!
    negtra = .false.
!
    do k = 1, nbmect
        ratio = yf(ndt+1+nbmeca+k)/maxi
        if (ratio .lt. (-tole1)) then
            if (indi(k) .le. 8) then
                negmul(indi(k)) = .true.
            else
! ----------------------------------------------
! ---> MECANISME DE TRACTION
! LAMBDA < 0 --> DESACTIVATION DU MECANISME POUR
! LA PROCHAINE TENTATIVE D'INTEGRATION
! ----------------------------------------------
                bnews(indi(k)-8) = .true.
                negtra = .true.
            endif
        endif
    enddo
!
!
! -------------------------------------------------------
! ---> MECANISME DE TRACTION
! LAMBDA < 0 --> TENTATIVE SUPPL D'INTEGRATION SI COMPT<5
! -------------------------------------------------------
    if (negtra) then
        if (compt .gt. 5) then
            noconv = .true.
            goto 2000
        else if (nbmeca.eq.0) then
            call lceqve(predi0, sigf)
            call lceqve(deps0, deps)
            aredec = arede0
            stopnc = stopn0
            loop = loop0
            iret = 0
            probt = .false.
            goto 30
        else
            call lceqve(predi0, sigf)
            call lceqve(sigd0, sigd)
            call lceqve(deps0, deps)
            call lceqvn(nvi, vind0, vind)
            aredec = arede0
            stopnc = stopn0
            loop = loop0
            iret = 0
            probt = .false.
            call lceqvn(nvi, vind, vinf)
            goto 30
        endif
    endif
!
! -------------------------------------------------------
! ---> MISE A JOUR DES CONTRAINTES ET VARIABLES INTERNES
! -------------------------------------------------------
!
    call lceqvn(ndt, yf, sigf)
    do i = 1, 3
        call hujprj(i, sigf, dev, pf, qf)
! ------------------------------------------------------
! ---> CONTROLE QUE MECANISME DE TRACTION RESPECTE MEME
!      S'IL N'ETAIT PAS ACTIVE
! ------------------------------------------------------
        if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. tole2) then
            bnews(i) = .false.
            tracti = .true.
        endif
    end do
    if ((tracti) .and. (nbmeca.gt.0)) then
        iret = 1
        goto 9999
    else if (tracti) then
! --- SI IL N Y A QUE DES MECANISMES DE TRACTION ACTIFS
! --- ALORS ON DEMANDE DIRECTEMENT SON ACTIVATION SANS
! --- REPASSER PAR L'ETAT INITIAL STANDARD
        call lceqve(deps0, deps)
!        CALL LCEQVE(PREDI0, SIGF)
        aredec = arede0
        stopnc = stopn0
        loop = loop0
        iret = 0
        probt = .false.
        goto 30
    endif
!af 15/05/07 Debut
    vinf(23) = yf(ndt+1)
!af 15/05/07 Fin
!
! ----------------------------------------------
! ---> AFFECTATION DES RAYONS DE YF VERS VINF
! --- ON S'ASSURE QUE (R+>=R-) ET (R+CYC<=RMON)
! ----------------------------------------------
    do k = 1, nbmeca
        kk = indi(k)
        if (yf(ndt+1+k) .gt. vind(kk)) then
            if ((kk.gt.4) .and. (kk.lt.8)) then
                if (yf(ndt+1+k) .le. vind(kk-4)) then
                    vinf(kk) = yf(ndt+1+k)
                else
                    vinf(kk) = vind(kk-4)
                endif
            else
                vinf(kk) = yf(ndt+1+k)
            endif
        else
            vinf(kk) = vind(kk)
        endif
    end do
!
! -------------------------------------
! --- CONTROLE DE L'EVOLUTION DE R(K)
!     SI DR/R > TOLE ---> SUBD = .TRUE.
! -------------------------------------
    evol = 0.1d0
    subd = .false.
    ndec0 = 1
    do k = 1, nbmeca
        kk = indi(k)
        ratio = (vinf(kk)-vind(kk))/vind(kk)
        if (ratio .gt. evol) then
            rdec = (vinf(kk)-vind(kk))/(evol*vind(kk))
            ndec = nint(rdec)
            if (ndec .lt. 1) ndec=1
            if (ndec .gt. nmax) ndec=nmax
            ndec0 = max(ndec, ndec0)
        endif
    end do
!
! -------------------------------------------------
! --- CONTROLE DE L'EVOLUTION DE EPS_V^P
!     SI DEPS_V^P/EPS_V^P > TOLE ---> SUBD = .TRUE.
! -------------------------------------------------
    ratio = zero
    if (abs(vind(23)) .gt. abs(crit(3))) ratio = (vinf(23)-vind(23))/vind(23)
    if ((ratio.gt.evol) .and. (abs(vind(23)).gt.crit(3))) then
        rdec = (vinf(23)-vind(23))/(evol*abs(vind(23)))
        ndec = nint(rdec)
        if (ndec .lt. 1) ndec=1
        if (ndec .gt. nmax) ndec=nmax
        ndec0 = max(ndec, ndec0)
    endif
    if (ndec0 .gt. 1) subd=.true.
    goto 2000
!
! ----------------------------------------------------------
! ETIQUETTE 9999 ---> GESTION DES NON CONVERGENCES LOCALES
!                     LIMITEES A 5 TENTATIVES
! ----------------------------------------------------------
9999 continue
    if (compt .gt. 5) then
        noconv = .true.
! --- ON REGARDE SI L'ETAT INITIAL MATERIAU AVAIT SOLLICITE
! --- UN MECANISME DE TRACTION : ETAT INIT = SIGD0
        do i = 1, ndi
            call hujprj(i, sigd0, dev, pf, qf)
            if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
                noconv=.false.
                iret = 0
            endif
        enddo
        if (.not.noconv) then
! --- EN POSANT NOCONV = .TRUE., ON CONDUIT L'ALGORITHME PRESENT
! --- DANS HUJRES A IMPOSER UN ETAT DE CONTRAINTES ISOTROPE COMMUN
! --- AUX 3 SEUILS PLASTIQUES DE TRACTION
!
            noconv=.true.
            call lceqve(sigd0, sigd)
            call lceqve(sigd0, sigf)
            call lceqvn(nvi, vind0, vind)
            call lceqvn(nvi, vind0, vinf)
        endif
        if (debug) write(6,*)'NOCONV =',noconv
        if (debug) write(6,*)'MECTRA =',mectra
        goto 2000
    endif
!
! --- Y AVAIT IL UN MECANISME CYCLIQUE DEJA DESACTIVE
!     DURANT CETTE TENTATIVE?
    msup(1) = 0
    msup(2) = 0
    msup(3) = 0
    msup(4) = 0
    j = 0
    do i = 5, 8
        if ((vind(23+i).ne.vind0(23+i)) .and. (vind(23+i).eq.zero)) then
            j = j+1
            msup(j) = i
        endif
    end do
!
    if (probt) then
        if (debug) write(6,'(A)')'HUJMID :: 9999 PROBT'
!
        call lceqve(predi0, sigf)
        call lceqve(sigd0, sigd)
        call lceqve(deps0, deps)
        call lceqvn(nvi, vind0, vind)
        aredec = arede0
        stopnc = stopn0
        loop = loop0
        do i = 1, 3
            if (prob(i) .eq. un) then
                vind(i+4) = mater(18,2)
                vind(23+i) = un
                vind(27+i) = zero
                vind(4*i+5) = zero
                vind(4*i+6) = zero
                vind(4*i+7) = zero
                vind(4*i+8) = zero
                vind(5*i+31) = zero
                vind(5*i+32) = zero
                vind(5*i+33) = zero
                vind(5*i+34) = zero
                vind(5*i+35) = mater(18,2)
            else if (prob(i).eq.deux) then
                vind(27+i) = zero
            endif
        enddo
        iret = 0
        probt = .false.
!
! --- MECANISME CYCLIQUE A DESACTIVE
! --- ET DEJA DESACTIVE ANTERIEUREMENT
        if (j .ne. 0) then
            do i = 1, j
                vind(23+msup(i)) = zero
            enddo
        endif
!
        call lceqvn(nvi, vind, vinf)
        goto 30
    endif
!
    if (tracti) then
        if (debug) write(6,'(A)') 'HUJMID :: 9999 TRACTI'
        call lceqve(deps0, deps)
        call lceqvn(nvi, vind0, vind)
        modif = .false.
        do i = 1, nbmect
            if (ye(ndt+1+nbmeca+i) .eq. zero) then
                modif = .true.
                if (indi(i) .le. 8) then
                    if (indi(i) .lt. 5) then
                        if ((abs(vind(4*indi(i)+5)).gt.r8prem()) .or.&
                            (abs(vind(4*indi(i)+6)).gt.r8prem())) then
                            vind(23+indi(i)) = -un
                        else
                            vind(23+indi(i)) = zero
                        endif
                    else
                        vind(23+indi(i)) = zero
                    endif
                else
                    bnews(indi(i)-8) = .true.
                    neglam(indi(i)-8) = .true.
                endif
                tracti = .false.
            endif
        enddo
!
        do i = 1, nbmect
            if (indi(i) .eq. 8) then
                vind(23+indi(i)) = zero
                modif = .true.
            endif
        enddo
!
        if (debug) write(6,*)'NEGLAM =',(neglam(i),i=1,3)
        mtrac = .false.
        do i = 1, 3
! --- ON NE DOIT PAS REACTIVE UN MECANISME DE TRACTION QUI DONNE
!     COMME PREDICTEUR UN MULTIPLICATEUR PLASTIQUE NEGATIF
            if (.not.neglam(i)) then
                call hujprj(i, yf, dev, pf, qf)
! ----------------------------------------------------
! ---> ACTIVATION MECANISMES DE TRACTION NECESSAIRES
! ----------------------------------------------------
                if (debug) write(6,*)'I=',i
                if (debug) write(6,*)'PK =',pf
                if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
                    bnews(i) = .false.
                    if(.not.modif)mtrac = .true.
                endif
            endif
        enddo
        call lceqve(predi0, sigf)
        call lceqve(sigd0, sigd)
        call lceqvn(nvi, vind, vinf)
        aredec = arede0
        stopnc = stopn0
        loop = loop0
        iret = 0
        probt = .false.
        goto 30
    endif
!
!-----------------------------------------------------------
! --- ESSAIS HEURISTIQUES POUR RELANCER LA RESOLUTION LOCALE
!-----------------------------------------------------------
    maxi = zero
    resi = 0
    do i = 1, nr
        if (abs(r(i)) .gt. maxi) then
            maxi = abs(r(i))
            resi = i
        endif
    end do
    cycl = .false.
    do i = 1, nbmeca
        if ((indi(i).gt.4) .and. (indi(i).lt.8) .and. (vind(indi(i)) .eq.mater(18,2))) then
            cycl = .true.
        endif
    end do
    if (debug) write(6,*) '9999 RESI:',resi
!
! ---------------------------------------------------------------
! --- SI RESIDU LOCAL MAXI PORTE PAR RDEV_CYC => MECANISME RETIRE
! ---------------------------------------------------------------
!
    if ((resi.gt.7) .and. (resi.le.7+nbmeca)) then
        resi = resi - 7
        if ((indi(resi).gt.4) .and. (indi(resi).lt.8)) then
!
            call lceqve(predi0, sigf)
            call lceqve(sigd0, sigd)
            call lceqve(deps0, deps)
            call lceqvn(nvi, vind0, vind)
            aredec = arede0
            stopnc = stopn0
            loop = loop0
            vind(23+indi(resi)) = zero
            if (j .ne. 0) then
                do i = 1, j
                    vind(23+msup(i)) = zero
                enddo
            endif
!
! --- EXISTE-T-IL UN MECANISME DEVIATOIRE AYANT LE MEME COMPORTEMENT
!     QUE CELUI IDENTIFIE PRECEDEMMENT COMME POSANT PROBLEME ?
            do i = 1, nbmeca
                if ((indi(i).gt.4) .and. (indi(i).lt.8) .and.&
                    (((maxi- abs(r(7+i)))/tole1).lt.tole1) .and. (i.ne.resi)) then
                    vind(23+indi(i)) = zero
                endif
            enddo
!
            iret = 0
            probt = .false.
            call lceqvn(nvi, vind, vinf)
            goto 30
        else
            noconv = .true.
            if (debug) write(6,*)'NOCONV2 =',noconv
            if (debug) write(6,*)'MECTRA2 =',mectra
        endif
    endif
!
! ---------------------------------------------------------------
! --- SI MECA CYCLIQUE ALORS ILS SONT RETIRES
! ---------------------------------------------------------------
!
    if (cycl) then
        if (debug) write(6,'(A)')'HUJMID :: 9999 CYCL'
        call lceqve(predi0, sigf)
        call lceqve(sigd0, sigd)
        call lceqve(deps0, deps)
        call lceqvn(nvi, vind0, vind)
        aredec = arede0
        stopnc = stopn0
        loop = loop0
        do i = 1, nbmeca
            if ((indi(i).gt.4) .and. (indi(i).lt.8) .and. (vind(indi( i)).eq.mater(18,2))) then
                vind(23+indi(i)) = zero
            endif
        enddo
        iret = 0
        probt = .false.
        call lceqvn(nvi, vind, vinf)
        goto 30
    endif
!
! ---------------------------------------------------------------
! --- SI MECANISME TRACTION ACTIF => RETIRE DE MPOT
! ---------------------------------------------------------------
!
    if (nbmect .ne. nbmeca) then
        if (debug) write(6,'(A)') '9999 FTRAC'
        call lceqve(predi0, sigf)
        call lceqve(sigd0, sigd)
        call lceqve(deps0, deps)
        call lceqvn(nvi, vind0, vind)
        aredec = arede0
        stopnc = stopn0
        loop = loop0
        iret = 0
        do i = nbmeca+1, nbmect
            if (ye(ndt+1+nbmeca+i) .eq. zero) then
                bnews(indi(i)-8) = .true.
            endif
        enddo
        probt = .false.
        call lceqvn(nvi, vind, vinf)
        goto 30
    endif
!
! ---------------------------------------------------------------
! --- CONTROLE DU PREDICTEUR ELASTIQUE: YE(LAMBDA)
! ---------------------------------------------------------------
!
    call lceqve(predi0, sigf)
    call lceqve(sigd0, sigd)
    call lceqve(deps0, deps)
    call lceqvn(nvi, vind0, vind)
    aredec = arede0
    stopnc = stopn0
    loop = loop0
    probt = .false.
    euler = .true.
    lamin = 1.d2
    imin = 0
    do i = 1, nbmeca
        if (ye(ndt+1+nbmeca+i) .eq. zero) then
            if ((indi(i).gt.4) .and. (indi(i).lt.9)) then
                vind(indi(i)+23) = 0
                euler = .false.
            else if (indi(i).lt.5) then
                if ((abs(vind(4*indi(i)+5)).gt.r8prem()) .or.&
                    (abs( vind(4*indi(i)+6)).gt.r8prem())) then
                    vind(23+indi(i)) = -un
                else
                    vind(23+indi(i)) = zero
                endif
                euler = .false.
            endif
        else if (ye(ndt+1+nbmeca+i).lt.lamin) then
            lamin = ye(ndt+1+nbmeca+i)
            imin = i
        endif
    end do
!
    if (.not.euler) then
! --- MECANISME CYCLIQUE A DESACTIVE
! --- ET DEJA DESACTIVE ANTERIEUREMENT
        if (j .ne. 0) then
            do i = 1, j
                vind(23+msup(i)) = zero
            enddo
        endif
!
        call lceqvn(nvi, vind, vinf)
        iret = 0
        goto 30
    else if (imin.gt.0) then
        if (indi(imin) .lt. 5) then
            vind(23+indi(imin)) = -un
        else
            vind(23+indi(imin)) = zero
        endif
        call lceqvn(nvi, vind, vinf)
        iret = 0
        goto 30
    endif
!
! ---------------------------------------------------------------
! --- DERNIER ESSAI: VALEUR DES CONTRAINTES PRE, DURANT ET POST
! ---------------------------------------------------------------
    ltry = .false.
    do i = 1, ndi
        call hujprj(i, sigd0, dev, pf, qf)
        if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
            noconv=.false.
            iret = 0
            bnews(i) = .false.
            ltry = .true.
        endif
        call hujprj(i, ye, dev, pf, qf)
        if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
            noconv=.false.
            iret = 0
            bnews(i) = .false.
            ltry = .true.
        endif
        call hujprj(i, yf, dev, pf, qf)
        if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
            noconv=.false.
            iret = 0
            bnews(i) = .false.
            ltry = .true.
        endif
        call hujprj(i, predi0, dev, pf, qf)
        if (((pf+rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
            noconv=.false.
            iret = 0
            bnews(i) = .false.
            ltry = .true.
        endif
    end do
!
    if (ltry) then
        call lceqvn(nvi, vind, vinf)
        iret = 0
        goto 30
    else
        noconv = .true.
    endif
!
!
    1000 format(a,15(1x,e12.5))
    1001 format(a,2(i3))
!
2000 continue
!
    if (debug) write(6,*)'HUJMID --- VINF =',(vinf(i),i=24,31)
    if (debug) write(6,*)'IRET - HUJMID =',iret
end subroutine
