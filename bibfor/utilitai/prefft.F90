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

subroutine prefft(resin, method, symetr, nsens, grand,&
                  vectot, nbva, kmpi, ier)
    implicit none
#include "jeveux.h"
#include "blas/dcopy.h"
#include "blas/zcopy.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/assert.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/gettco.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsorac.h"
#include "asterfort/spdfft.h"
#include "asterfort/vecini.h"
#include "asterfort/vecinc.h"
#include "asterfort/vecint.h"
#include "asterfort/wkvect.h"
    integer :: npara, nsens
    character(len=4) :: grand
    character(len=16) :: symetr, method, kmpi
    character(len=19) :: resin, vectot
!     REALISATION N.GREFFET
!     OPERATEUR "ENVOI A FFT : CREATION DE FONCTIONS"
!     IN:
!       RESIN    : SD_RESULTAT INITIALE HARMONIQUE
!                  (VENANT DE DYNA_VIBRA//HARM OU //TRAN/GEN)
!       METHOD   : METHODE POUR FFT
!       SYMETRIE : SPECTRE SYMETRIQUE OU NON
!       NSENS    : SENS FFT (1=DIRECT,-1=INVERSE)
!       GRAND    : GRANDEUR PHYSIQUE (DEPL,VITE,ACCE)
!       KMPI     : ACCELERATION MPI
!
!     OUT:
!       NPARA : POINTEUR DU TABLEAU DE DONNEE VENANT DE LA FFT
!       NBVA  : NOMBRE DE PAS DE TEMPS
!
!
!
!
!
!     ------------------------------------------------------------------
    integer :: nbva, n, nbpts, nbpts1, nbpts2
    integer :: nbordr, jordr, ibid, i, ii
    integer :: iordr, lacce, lfon, iddl, neq
    integer :: lvar, ier, lordr, lval, iret, tord(1)
    integer :: lvale, nout, nbvout, lfon2, j, ltra
    real(kind=8) :: r8b, dimag, rzero
    complex(kind=8) :: c16b,czero
    character(len=3) :: k3
    character(len=4) :: grande
    character(len=8) :: k8b
    character(len=16) :: sym
    character(len=19) :: chdep, knume, cham19, nomfon, fonout, nomwor, kcham
    character(len=24) :: chdep2, typres, kdist
    aster_logical :: ldist, dbg_ob, lmkl
    mpi_int       :: mpicou, mpicow, mrang, mnbproc
    integer       :: rang, nbproc, nbloc, impi, iaux, jkdist, ndist
    integer       :: ifm, niv, nbout, minj, maxj, ndist1, lcham

!
    call jemarq()
! INIT
    call infniv(ifm, niv)
    rzero=0.D0
    czero=dcmplx(0.D0,0.D0)
! MODE DEBUG
    if (niv.ge.2) then
      dbg_ob=.true.
    else
      dbg_ob=.false.
    endif
! MODE DISTRIBUE OU NON
    ldist=.false.
    if (kmpi(1:3).eq.'OUI') then
      ldist=.true.
    else if (kmpi(1:3).eq.'NON') then
      ldist=.false.
    else
! valeur aberrante
      ASSERT(.false.)
    endif
    if (dbg_ob) then
      write(ifm,*)'valeur kmpi/ldist=',kmpi,ldist
    endif
! CHOIX DE LA MKL
    lmkl=.true.
    lmkl=.false.
    if (lmkl) then
      k3='MKL'
    else
      k3='AST'
    endif
! PREPARATION DEU VECTEUR DE DISTRIBUTION MPI DES CALCULS "IDDL"
! SI LDIST=.TRUE.
!   KDIST(1...NEQ), KDIST(I)=RANG DU PROC MPI CONCERNE PAR LE IEME DDL
!   DISTRIBUTION CONTIGUEE AVEC RELIQUAT POUR LE DERNIER PROCESSUS
!   LE PREMIER DDL EST FAIT PAR TOUS (POUR DIMENSIONNER TABLEAUX)
! SI LDIST=.FALSE.
!   KDIST(I)=RANG DU PROCESSUS COURANT POUR TOUT I.
    call asmpi_comm('GET_WORLD', mpicow)
    call asmpi_comm('GET', mpicou)
    if (mpicow.ne.mpicou) then
      ASSERT(.False.)
    endif
    call asmpi_info(mpicou, mrang, mnbproc)
    rang = to_aster_int(mrang)
    nbproc = to_aster_int(mnbproc)
! GARDES-FOUS
    ASSERT((rang.ge.0).and.(rang.le.(nbproc-1)))
    ASSERT(nbproc.ge.1)
    if (ldist.and.(nbproc.eq.1)) then
      ldist=.false.
      if (dbg_ob)&
        write(ifm,*)'<PREFFT> CALCUL SEQUENTIEL, LDIST FORCE A .FALSE.'
    endif
!     ------------------------------------------------------------------
!      pour ne pas invalider NPARA
    grande = grand
    ier = 0
!
    call gettco(resin, typres)
    call jelira(resin//'.ORDR', 'LONUTI', nbordr)
    call rsorac(resin,'LONUTI',0,r8b,k8b,c16b,r8b,k8b,tord,1,ibid)
    nbordr=tord(1)            
    knume='KNUME'
    call wkvect(knume, 'V V I', nbordr, jordr)
    call rsorac(resin,'TOUT_ORDRE',0,r8b,k8b,c16b,r8b,k8b,zi(jordr),nbordr,ibid)
    call jeveuo(knume, 'L', lordr)
!
!    Creation objet fonction
!
    nomfon = '&&PREFFT.FON_AV'
    if (nsens .eq. 1) then
      call wkvect(nomfon, 'V V R', 2*nbordr, lvar)
    else if (nsens.eq.-1) then
      call wkvect(nomfon, 'V V R', 3*nbordr, lvar)
    endif
    lfon = lvar + nbordr
!
!    Creation vecteurs pour economiser appels rsexch si DYNA_TRANS/HARMO
    kcham= '&&PREFFT.KCHAM'
    call wkvect(kcham, 'V V K24', nbordr, lcham)
!
    if (typres(6:9) .ne. 'GENE') then
      call rsexch('F', resin, grande, 1, chdep, iret)
      call jeveuo(chdep//'.VALE', 'L', lval)
!     --- NOMBRE D'EQUATIONS : NEQ
      chdep2 = chdep(1:19)//'.VALE'
      call jelira(chdep2, 'LONMAX', neq)
    else
      call jeveuo(resin//'.'//grande, 'L', lval)
      chdep2 = resin//'.'//grande
      call jelira(chdep2, 'LONMAX', neq)
      neq = neq / nbordr
      call jeveuo(resin//'.DISC', 'L', lacce)
!      --- LACCE : ACCES A LA LISTE D'INSTANTS/FREQUENCES
    endif

! CREATION DU VECTEUR KDIST
    ndist=neq
    ndist1=ndist-1
! POUR DIAGNOSTIC DEBUG
    if (dbg_ob) then
      write(ifm,*)'<PREFFT> NEQ/NBPROC/RANG/LDIST=',neq,nbproc,rang,ldist
      write(ifm,*)'<PREFFT> TYPRES=',typres
    endif
!    
! GARDE-FOU: AU MOINS UN CALCUL FFT (BOUCLE IDDL=2,NEQ) PAR MPI
    if (ndist1.lt.nbproc) then
      ldist=.false.
      if (dbg_ob)&
        write(ifm,*)'<PREFFT> CALCUL TROP PETIT, LDIST FORCE A .FALSE.'
    endif
    kdist='&&PREFFT.VEC_DIST_MPI'
    call wkvect(kdist, 'V V I', ndist, jkdist)
    if (ldist) then
! LES PROC MPI SE DISTRIBUENT LES DDLS; RELIQUAT AU DERNIER
! DESEQUILIBRAGE DE CHARGE AU PIRE EN nbproc NEGLIGEABLE PAR RAPPORT A
! LA CHARGE (neq-1)/nbproc
! TOUS LES PROC MPI FONT LE PREMIER DDL
      zi(jkdist)=rang
      nbloc=ndist1/nbproc
      impi=0
      iaux=0
      do i=1,ndist1
        iaux=iaux+1
        zi(jkdist+i)=impi
        if ((iaux==nbloc).and.(impi<(nbproc-1))) then
          iaux=0
          impi=impi+1 
        endif
      enddo
    else
! TOUS LES PROC MPI FONT TOUS LES DDLS
      call vecint(ndist,rang,zi(jkdist))
    endif
! POUR DIAGNOSTIC DEBUG
    if (dbg_ob) then
      write(ifm,*)'<PREFFT> NDIST/NBPROC/NBLOC=',ndist,nbproc,nbloc
      do j=0,nbproc-1
        minj=ndist+1
        maxj=0
        do i=1,ndist1
          if (zi(jkdist+i).eq.j) then
            if ((i+1).lt.minj) minj=i+1
            if ((i+1).gt.maxj) maxj=i+1
          endif
        enddo
        write(ifm,*)'RANG/IMIN_KDIST/IMAX_KDIST',j,minj,maxj
      enddo
    endif
!
! INIT
    iddl = 1
    ii = 0
    sym = symetr
!
! PREPARATION POUR SPDFFT
    nbva=nbordr
    n = 1
 2  continue
    nbpts = 2**n
    if (nbpts .lt. nbva) then
      n = n + 1
      goto 2
    endif
!     Methode de prise en compte du signal :
!     -TRONCATURE : on tronque au 2**N inferieur le plus proche de NBVA
!     -PROL_ZERO : on prolonge le signal avec des zero pour aller
!                   au 2**N le plus proche superieur a NBVA
    if ((method.eq.'TRONCATURE') .and. (nbpts.ne.nbva)) then
      nbpts = 2**(n-1)
      nbpts1 = nbpts
      nbpts2 = 2*nbpts
    else
      nbpts = 2**n
      nbpts1 = nbva
      nbpts2 = nbpts
    endif
    if (sym .eq. 'NON') then
     if (nsens .eq. 1) then
       nbpts2 = (nbpts/2)
     else if (nsens.eq.-1) then
       nbpts2 = (2*nbpts)
     endif
    endif
    nomwor='&&PREFFT.TRAVAIL'
    fonout = '&&PREFFT.FCTFFT'
    if (nsens.eq.1) then
      call wkvect(nomwor,'V V C', nbpts, ltra)
      call wkvect(fonout,'V V C', 2*nbpts2, nout)
    else if (nsens.eq.-1) then
      call wkvect(nomwor,'V V C', nbpts2+1, ltra)
      call wkvect(fonout,'V V R', 2*nbpts2, nout)
    endif
    nbvout=nbpts2
!
    if (nsens .eq. 1) then
!     --- DE TEMPOREL EN FREQUENTIEL : TRAN_GENE EN HARM_GENE
!         OU BIEN DYNA_TRANS EN DYNA_HARMO
!
!        --- PREMIER FFT SUR UN SEUL DDL DANS LE BUT DE DIMENSIONNER
!            LE VECTEUR RESULTAT VECTOT, INDEXE PAR NPARA
        if (typres .ne. 'TRAN_GENE') then
!        --- CAS OU ON DISPOSE D'UNE DYNA_TRANS:
            do 5 iordr = 0, nbordr-1
!           --- BOUCLE SUR LES NUMEROS D'ORDRE (INSTANTS ARCHIVES)
                call rsexch('F',resin,grande,zi(jordr+iordr),cham19,iret)
                zk24(lcham+iordr)=cham19
                call rsadpa(resin, 'L', 1, 'INST', zi(jordr+iordr),&
                            0, sjv=lacce, styp=k8b)
                call jeveuo(cham19//'.VALE', 'L', lvale)
!              --- REMPLIR LE VECTEUR ABSCISSES DE LA FONCTION PREFFT
!                  AVEC LA LISTE D'INSTANTS RECUPEREE
                zr(lvar+iordr) = zr(lacce)
!              --- REMPLIR LE VECTEUR ORDONNES DE LA FONCTION PREFFT
!                  AVEC LE CHAMP RECUPERE
                zr(lfon+ii) = zr(lvale+iddl-1)
                ii = ii + 1
                call jelibe(cham19//'.VALE')
 5          continue
        else
!        --- CAS D'UNE TRAN_GENE:
!              --- REMPLIR L'ABSCISSE DE LA FONCTION PREFFT
            call dcopy(nbordr,zr(lacce),1,zr(lvar),1)
            call dcopy(nbordr,zr(lval+iddl-1),neq,zr(lfon),1)
        endif
!
!
! TOUS LES PROCESSUS MPI FONT LE CALCUL
!       
!        --- CALCUL DE LA FFT DE LA FONCTION PREFFT DEFINIE PRECEDEMNT
        call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!
!        --- VERIFICATIONS AVANT CREATION DE LA VECTEUR DES FFT FINAL
        call jeexin(vectot, iret)
        if (iret .ne. 0) call jedetr(vectot)
!
!        --- CREATION DU VECTEUR DES FFTS
        nbout=(neq+1)*nbvout
        call wkvect(vectot, 'V V C', nbout, npara)
        call vecinc(nbout,czero,zc(npara))
!
!        --- REMPLISSAGE AVEC LES PREMIERS RESULTATS POUR IDDL=1
        lfon2 = nout + nbvout
        call zcopy(nbvout,zc(lfon2),1,zc(npara+(iddl-1)*nbvout),1)
!
!        --- BOUCLE DES FFTS SUR LES AUTRES DDL'S
!            REFERER AUX PRECEDENTS COMMENTAIRES POUR + DE DETAILS
        if (typres .ne. 'TRAN_GENE') then
!        --- CAS D'UNE DYNA_TRANS A L'ENTREE
            call jelibe(cham19//'.VALE')
!           --- BOUCLE SUR LES DDL'S 2 A NEQ
            do 10 iddl = 2, neq
! ON LIMITE LE CALCUL FFT AUX IDDL DE LA RESPONSABILITE DU PROCESSUS MPI
              if (zi(jkdist+iddl-1).eq.rang) then
                ii = 0
!              --- REMPLISSAGE ORDONNEES DE LA FONCTION PREFFT
                do 20 iordr = 0, nbordr-1
                    cham19=zk24(lcham+iordr)(1:19)
                    call jeveuo(cham19//'.VALE', 'L', lvale)
                    zr(lfon+ii) = zr(lvale+iddl-1)
                    ii = ii + 1
                    call jelibe(cham19//'.VALE')
20              continue
!              --- CALCUL DES FFT
                call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!              --- SAUVEGARDE DES RESULTATS DANS VECTOT
                lfon2 = nout + nbvout
                call zcopy(nbvout,zc(lfon2),1,zc(npara+(iddl-1)*nbvout),1)
              endif
10          continue
!
! COMMUNICATION DES RESULTATS
            if (ldist) then
! POUR DIAGNOSTIC DEBUG
              if (dbg_ob) then
           write(ifm,*)'<PREFFT> DYNA_TRANS NSENS=1'
           write(ifm,*)'<PREFFT> !! COM MPI_ALLREDUCE C DE TAILLE=',(neq-1)*nbvout,' !!'
              endif
! ON COMMUNIQUE PAS LE PREMIER (FFT FAIT PAR TOUS) ET PAS LE DERNIER (LISTE DES INSTANTS
! CONNUES DE TOUS CF. BOUCLE 40)
              call asmpi_comm_vect('MPI_SUM','C',nbval=(neq-1)*nbvout,vc=zc(npara+nbvout))
            endif
        else
!        --- CAS D'UNE TRAN_GENE A L'ENTREE
!           --- BOUCLE SUR LES DDL'S 2 A NEQ
            do 11 iddl = 2, neq
! ON LIMITE LE CALCUL FFT AUX IDDL DE LA RESPONSABILITE DU PROCESSUS MPI
              if (zi(jkdist+iddl-1).eq.rang) then
                ii = 0
!              --- REMPLISSAGE ORDONNEES DE LA FONCTION PREFFT
                call dcopy(nbordr,zr(lval+iddl-1),neq,zr(lfon),1)
!              --- CALCUL DES FFT
                call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!              --- SAUVEGARDE DES RESULTATS DANS VECTOT
                lfon2 = nout + nbvout
                call zcopy(nbvout,zc(lfon2),1,zc(npara+(iddl-1)*nbvout),1)
              endif
11          continue
!
! COMMUNICATION DES RESULTATS
            if (ldist) then
! POUR DIAGNOSTIC DEBUG
              if (dbg_ob) then
           write(ifm,*)'<PREFFT> TRAN_GENE NSENS=1'
           write(ifm,*)'<PREFFT> !! COM MPI_ALLREDUCE C DE TAILLE=',(neq-1)*nbvout,' !!'
              endif
! ON COMMUNIQUE PAS LE PREMIER (FFT FAIT PAR TOUS) ET PAS LE DERNIER (LISTE DES INSTANTS
! CONNUES DE TOUS CF. BOUCLE 40)
              call asmpi_comm_vect('MPI_SUM','C',nbval=(neq-1)*nbvout,vc=zc(npara+nbvout))
            endif
        endif
!
!        --- STOCKAGE DES INSTANTS A LA FIN DANS VECTOT
         call zcopy(nbvout,zc(nout),1,zc(npara+neq*nbvout),1)
!
    else if (nsens.eq.-1) then
!     --- DE FREQUENTIEL EN TEMPOREL : HARM_GENE EN TRAN_GENE
!         OU BIEN DYNA_HARMO EN DYNA_TRANS
!
!        --- PREMIER FFT_INV SUR UN SEUL DDL DS LE BUT DE DIMENSIONNER
!            LE VECTEUR RESULTAT VECTOT, INDEXE PAR NPARA
        if (typres .ne. 'HARM_GENE') then
!        --- CAS D'UNE SD ENTRANTE HARMONIQUE SUR BASE PHYSIQUE
!            => SD_RESULTAT
            do 50 iordr = 1, nbordr
!             --- REMPLIR L'ABSCISSE ET ORDONNE DE LA FONCTION PREFFT
!             --- NOTE : VALEURS DES CHAMPS SONT COMPLEXES
                call rsexch('F', resin, grande, zi(jordr+iordr-1), cham19, iret)
                zk24(lcham+iordr-1)=cham19
                call rsadpa(resin, 'L', 1, 'FREQ', zi(jordr+iordr-1),&
                            0, sjv=lacce, styp=k8b)
                call jeveuo(cham19//'.VALE', 'L', lvale)
                zr(lvar+iordr-1) = zr(lacce)
                zr(lfon+ii) = dble(zc(lvale+iddl-1))
                ii = ii + 1
                zr(lfon+ii) = dimag(zc(lvale+iddl-1))
                ii = ii + 1
                call jelibe(cham19//'.VALE')
50          continue
        else
!        --- CAS D'UNE SD HARM_GENE
            do 51 iordr = 0, nbordr-1
!             --- REMPLIR L'ABSCISSE ET ORDONNE DE LA FONCTION PREFFT
!             --- NOTE : VALEURS DES CHAMPS SONT COMPLEXES
                zr(lvar+iordr) = zr(lacce+iordr)
                zr(lfon+ii) = dble(zc(lval+iddl-1+(neq*iordr)))
                ii = ii + 1
                zr(lfon+ii) = dimag(zc(lval+iddl-1+(neq*iordr)))
                ii = ii + 1
51          continue
        endif
! BIZARRE
        if (abs(zr(lfon+ii-1)) .lt. ((1.d-6)*abs(zr(lfon+ii-2)))) then
            zr(lfon+ii-1) = 0.d0
        endif
!
! TOUS LES PROCESSUS MPI FONT LE CALCUL
!
!        --- CALCUL DU PREMIER FFT INVERSE SUR LA FONCTION CALCULEE
        call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!
!        --- VERIFICATIONS AVANT CREATION DE LA VECTEUR DES FFT FINAL
        call jeexin(vectot, iret)
        if (iret .ne. 0) call jedetr(vectot)
!
!        --- CREATION DU VECTEUR DES FFTS
        nbout=(neq+1)*nbvout
        call wkvect(vectot, 'V V R', nbout, npara)
! INITIALISATION DE LA MATRICE DES RESULTATS
        call vecini(nbout,rzero,zr(npara))
!        --- REMPLISSAGE AVEC LES PREMIERS RESULTATS POUR IDDL=1
        lfon2 = nout + nbvout
        call dcopy(nbvout,zr(lfon2),1,zr(npara+(iddl-1)*nbvout),1)
!
!        --- BOUCLE DES FFTS INVERSES SUR LES AUTRES DDL'S
!            REFERER AUX PRECEDENTS COMMENTAIRES POUR + DE DETAILS
        if (typres .ne. 'HARM_GENE') then
            call jelibe(cham19//'.VALE')
!          --- BOUCLE SUR LES AUTRES DDLS DE 2 A NEQ
            do 100 iddl = 2, neq
! ON LIMITE LE CALCUL FFT AUX IDDL DE LA RESPONSABILITE DU PROCESSUS MPI
              if (zi(jkdist+iddl-1).eq.rang) then
                ii = 0
                do 70 iordr = 1, nbordr
                    cham19=zk24(lcham+iordr-1)(1:19)
                    call jeveuo(cham19//'.VALE', 'L', lvale)
                    zr(lfon+ii) = dble(zc(lvale+iddl-1))
                    ii = ii + 1
                    zr(lfon+ii) = dimag(zc(lvale+iddl-1))
                    ii = ii + 1
                    call jelibe(cham19//'.VALE')
70              continue
!             --- CALCUL DES FFT'S INVERSES
                call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!             --- SAUVEGARDE DES RESULTATS DANS VECTOT
                lfon2 = nout + nbvout
                call dcopy(nbvout,zr(lfon2),1,zr(npara+(iddl-1)*nbvout),1)
              endif
100         continue
!
! COMMUNICATION DES RESULTATS
            if (ldist) then
! POUR DIAGNOSTIC DEBUG
              if (dbg_ob) then
           write(ifm,*)'<PREFFT> DYNA_HARMO NSENS=-1'
           write(ifm,*)'<PREFFT> !! COM MPI_ALLREDUCE R DE TAILLE=',(neq-1)*nbvout,' !!'
              endif
! ON COMMUNIQUE PAS LE PREMIER (FFT FAIT PAR TOUS) ET PAS LE DERNIER (LISTE DES INSTANTS
! CONNUES DE TOUS CF. BOUCLE 400)
              call asmpi_comm_vect('MPI_SUM','R',nbval=(neq-1)*nbvout,vr=zr(npara+nbvout))
            endif
        else
            do 101 iddl = 2, neq
! ON LIMITE LE CALCUL FFT AUX IDDL DE LA RESPONSABILITE DU PROCESSUS MPI
              if (zi(jkdist+iddl-1).eq.rang) then
                ii = 0
                do 102 iordr = 0, nbordr-1
!               --- REMPLIR L'ABSCISSE ET ORDONNE DE LA FONCTION PREFFT
                    zr(lfon+ii) = dble(zc(lval+iddl-1+(neq*iordr)))
                    ii = ii + 1
                    zr(lfon+ii) = dimag(zc(lval+iddl-1+(neq*iordr)))
                    ii = ii + 1
102              continue
!             --- CALCUL DES FFT'S INVERSES
                call spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2, sym)
!             --- SAUVEGARDE DES RESULTATS DANS VECTOT
                lfon2 = nout + nbvout
                call dcopy(nbvout,zr(lfon2),1,zr(npara+(iddl-1)*nbvout),1)
              endif
101         continue
!
! COMMUNICATION DES RESULTATS
            if (ldist) then
! POUR DIAGNOSTIC DEBUG
              if (dbg_ob) then
           write(ifm,*)'<PREFFT> HARM_GENE NSENS=-1'
           write(ifm,*)'<PREFFT> !! COM MPI_ALLREDUCE R DE TAILLE=',(neq-1)*nbvout,' !!'
              endif
! ON COMMUNIQUE PAS LE PREMIER (FFT FAIT PAR TOUS) ET PAS LE DERNIER (LISTE DES INSTANTS
! CONNUES DE TOUS CF. BOUCLE 400)
              call asmpi_comm_vect('MPI_SUM','R',nbval=(neq-1)*nbvout,vr=zr(npara+nbvout))
            endif
        endif
! On stocke les instants a la fin
!
        call dcopy(nbvout,zr(nout),1,zr(npara+neq*nbvout),1)
    endif
    if (typres(6:9) .ne. 'GENE') call jelibe(cham19//'.VALE')
!
    nbva = nbvout
    call jedetr(knume)
    call jedetr(nomfon)
    call jedetr(kdist)
    call jedetr(nomwor)
    call jedetr(fonout)
    call jedetr(kcham)
    call jedema()
end subroutine
