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

subroutine calcop(option, lisopt, resuin, resuou, lisord,&
                  nbordr, chtype, typesd, codret, base, tldist)
    implicit none
!     --- ARGUMENTS ---
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/ccchel.h"
#include "asterfort/ccchno.h"
#include "asterfort/ccliop.h"
#include "asterfort/cclodr.h"
#include "asterfort/cclord.h"
#include "asterfort/ccnett.h"
#include "asterfort/ccvepo.h"
#include "asterfort/codent.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/infniv.h"
#include "asterfort/getvtx.h"
#include "asterfort/indk16.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/medom2.h"
#include "asterfort/pcptcc.h"
#include "asterfort/reliem.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsexc1.h"
#include "asterfort/rslesd.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsorac.h"
#include "asterfort/srmedo.h"
#include "asterfort/utmess.h"
#include "asterfort/vecint.h"
#include "asterfort/wkvect.h"
!
    integer :: nbordr, codret, tbid(1)
    character(len=1), optional, intent(in) :: base
    character(len=4) :: chtype
    character(len=8) :: resuin, resuou
    character(len=16) :: option, typesd
    character(len=19) :: lisord
    character(len=*) :: lisopt
    aster_logical, optional :: tldist
!  CALC_CHAMP - CALCUL D'UNE OPTION
!               ----         --
! ----------------------------------------------------------------------
!
!  ROUTINE DE BASE DE CALC_CHAMP
!
! IN  :
!   OPTION  K16  NOM DE L'OPTION A CALCULER
!   RESUIN  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT IN
!   RESUOU  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT OUT
!   NBORDR  I    NOMBRE DE NUMEROS D'ORDRE
!   LISORD  K19  LISTE DE NUMEROS D'ORDRE
!   CHTYPE  K4   TYPE DES CHARGES
!   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
!   BASE    K1   BASE SUR LAQUELLE SERA SAUVEGARDEE LES CHAMP
!                DEMANDES
!
! IN/OUT :
!   LISOPT  K19  LISTE D'OPTIONS A METTRE SUR LA BASE GLOBALE
!                ATTENTION CETTE LISTE PEUT ETRE MODIFIEE PAR CALCOP
!                LES OPTIONS DECLENCHEES SONT SUPPRIMEES DE LA LISTE
!   TLDIST LOG   SI PRESENT, ON CHERCHE LE MOT-CLE PARALLELISME_TEMPS
!                ET SI POSSIBLE ON L'ACTIVE.
!
! OUT :
!   CODRET  I    CODE RETOUR (0 SI OK, 1 SINON)
! ----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
    aster_logical :: exitim, exipou, optdem, dbg_ob, dbgv_ob, lcpu, ltest, ldist
    aster_logical :: ligmod, lbid, lsdpar
    mpi_int :: mpicou, mpibid
!
    integer :: nopout, jlisop, iop, ibid, nbord2, lres, n0, n1, n2, n3, posopt, jvcham
    integer :: nbtrou, minord, maxord, jlinst, iordr, nbordl, lcompo, rang, nbproc
    integer :: numord, iret, npass, nbma, codre2, jliopg, nbopt, ipas, nbpas, jldist
    integer :: jacalc, nordm1, jpara, nbchre, ioccur, icompo, ncharg, p, k, numork
    integer :: ideb, ifin, irelat, ifm, niv, lonch, lonnew
!
    real(kind=8) :: r8b
    real(kind=8), pointer :: noch(:) => null()
    real(kind=8), pointer :: prbid(:) => null()
!
    complex(kind=8) :: c16b
    complex(kind=8), pointer :: nochc(:) => null()
    complex(kind=8), pointer :: pcbid(:) => null()
!
    character(len=1) :: basopt, kbid, ktyp
    character(len=5) :: numopt
    character(len=8) :: modele, carael, k8b, sd_partition, modnew
    character(len=8) :: nomail, nobase, modeli
    character(len=11) :: nobaop
    character(len=16) :: optio2, typmcl(4), motcle(4),valk(2)
    character(len=19) :: nonbor, compor, lischa, k19b, nochou, nochok
    character(len=24) :: chaout, ligrel, mater, ligres, mateco, k24b, vldist, vcham, vcnoch
    character(len=24) :: noliop, lisins, mesmai, lacalc, suropt, mode24, chamno
!
    call jemarq()
    call infniv(ifm, niv)
    codret = 1
    npass = 0
    nobase = '&&CALCOP'
    lischa = '&&CALCOP.LISCHA'
    ncharg = 0
!
!     ON CONSERVE CES OPTIONS POUR PERMETTRE LE CALCUL DANS STANLEY
    if ((option.eq.'ERTH_ELEM') .or. (option.eq.'ERTH_ELNO')) goto 999
!
    if ((option.eq.'ERME_ELEM') .or. (option.eq.'ERME_ELNO') .or. (option.eq.'QIRE_ELEM') .or.&
        (option.eq.'QIRE_ELNO')) goto 999
!
    if ((option.eq.'SIZ1_NOEU') .or. (option.eq.'SIZ2_NOEU') .or. (option.eq.'ERZ1_ELEM') .or.&
        (option.eq.'ERZ2_ELEM') .or. (option.eq.'QIZ1_ELEM') .or. (option.eq.'QIZ2_ELEM')) &
    goto 999
!
    if ((option.eq.'SING_ELEM') .or. (option.eq.'SING_ELNO')) goto 999
!
    call ccliop('OPTION', option, nobase, noliop, nopout)
    if (nopout .eq. 0) goto 999


!
!
    if (option(1:4).eq.'EPSI')then
! ------get COMPORTEMENT from RESULT
        call rsexch(' ', resuin, 'COMPORTEMENT', 1, compor, lcompo)
        if (lcompo .eq.0) then
! ------get DEFORMATION value from RESULT
            call jeveuo(compor//'.VALE','L',icompo)
! ------Coherence verification for large deformation
            if ((zk16(icompo+43-1)(1:8) .eq. 'GDEF_LOG').or. &
                (zk16(icompo+43-1)(1:10) .eq. 'SIMO_MIEHE'))then
                valk(1) = zk16(icompo+43-1)
                if (zk16(icompo+43-1)(1:8) .eq. 'GDEF_LOG') then
                    valk(2) = 'EPSL_'//option(6:10)
                else
                    valk(2) = 'EPSG_'//option(6:10)
                endif
                call utmess('A','CALCCHAMP_3',nk=2,valk=valk)
            endif
        endif
    endif
!
    nonbor = nobase//'.NB_ORDRE'
    lacalc = nobase//'.ACALCULER'
!
    call jeveuo(noliop, 'L', jlisop)
!
    jliopg = 0
    nbopt = 0
    if (lisopt .ne. ' ') then
        call jeveuo(lisopt, 'E', jliopg)
        call jelira(lisopt, 'LONMAX', nbopt)
    endif
!
    exitim = .false.
    call jenonu(jexnom(resuin//'           .NOVA', 'INST'), iret)
    if (iret .ne. 0) exitim = .true.
!
    call rsorac(resuin, 'TOUT_ORDRE', ibid, r8b, k8b,&
                c16b, r8b, k8b, tbid, 1,&
                nbtrou)
    if (nbtrou .lt. 0) nbtrou = -nbtrou
    call wkvect(nonbor, 'V V I', nbtrou, lres)
    call rsorac(resuin, 'TOUT_ORDRE', ibid, r8b, k8b,&
                c16b, r8b, k8b, zi(lres), nbtrou,&
                nbord2)
!     ON EN EXTRAIT LE MIN ET MAX DES NUMEROS D'ORDRE DE LA SD_RESUTLAT
    minord = zi(lres)
    maxord = zi(lres+nbord2-1)
!
    call rslesd(resuin, minord, modele, mater(1:8), carael)
    call rsadpa(resuin, 'L', 1, 'MODELE', minord,&
                0, sjv=jpara)
    if (zk8(jpara) .ne. modele .and. zk8(jpara) .ne. ' ') then
        call utmess('A', 'CALCULEL_24')
    endif
!
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=nomail)
!
    call dismoi('MODELISATION', modele, 'MODELE', repk=modeli)
!
    if ((modeli(1:6).eq.'C_PLAN').and.(option(1:4).eq.'EPSI')&
        .and. (lcompo .eq. 0)) then
        if (zk16(icompo+41-1)(1:4) .ne. 'ELAS' .and. &
            zk16(icompo+41-1)(1:16) .ne. '                ') then
            call utmess('A', 'ELEMENTS3_11')
        endif
    endif
!  ROUTINE PERMETTANT DE SAVOIR SI DES POUTRES SONT DANS LE LIGREL
!   REDUIT ET DE VERIFIER LES CHARGES REPARTIES
    call ccvepo(modele, resuin, typesd, lisord, nbordr,&
                option,&
                nbchre, ioccur, suropt, ligrel, exipou)
!
    if (option(6:9) .eq. 'NOEU') then
        nbma = 0
        n0 = getexm(' ','GROUP_MA')
        n1 = getexm(' ','MAILLE')
        mesmai = '&&OP0106.MES_MAILLES'
        if (n0+n1 .ne. 0) then
            call getvtx(' ', 'MAILLE', nbval=0, nbret=n2)
            call getvtx(' ', 'GROUP_MA', nbval=0, nbret=n3)
            if (n2+n3 .ne. 0) then
                motcle(1) = 'GROUP_MA'
                motcle(2) = 'MAILLE'
                typmcl(1) = 'GROUP_MA'
                typmcl(2) = 'MAILLE'
                call reliem(' ', nomail, 'NU_MAILLE', ' ', 1,&
                            2, motcle, typmcl, mesmai, nbma)
            endif
        endif
    endif
!
!     PREMIER PASSAGE POUR DETERMINER LES OPTIONS REELLEMENT A CALCULER
!     EN PRENANT EN COMPTE LA DEPENDANCE
!     PAR EXEMPLE SI SIGM_NOEU A BESOIN DE SIGM_ELNO QUI A BESOIN DE
!     SIGM_ELGA ET QUE SIGM_ELNO EST PRESENTE ALORS ON N'A PAS BESOIN
!     DE CALCULER SIGM_ELGA
    call wkvect(lacalc, 'V V I', nopout, jacalc)
!
!     PAR DEFAUT, ON DOIT TOUT CALCULER
!     ON COMMENCE PAR CALCULER LA LISTE DE NUMEROS D'ORDRE
    do iop = 1, nopout
        optio2 = zk24(jlisop+iop-1)(1:16)
!
        optdem = .false.
        if (option .eq. optio2) optdem = .true.
!
        call cclord(iop, nbordr, lisord, nobase, optdem,&
                    minord, maxord, resuin, resuou, lisins)
        zi(jacalc-1+iop) = 1
    end do
!
!     PUIS ON RETIRE LES OPTIONS DONT LE CALCUL N'EST PAS UTILE
    do iop = nopout-1, 1, -1
        optio2 = zk24(jlisop+iop-1)(1:16)
!
        call cclodr(iop, nbordr, lisord, nobase, minord,&
                    maxord, resuin, resuou, lacalc)
    end do
!
!
!     COMME ON PARCOURT LES OPTIONS DANS L'ORDRE INVERSE DES DEPENDANCES
!     ON SAIT QUE LES LISTES D'INSTANT SERONT CORRECTEMENT CREES
    nobaop = nobase//'.OP'
    do iop = 1, nopout
        if (zi(jacalc-1+iop) .eq. 0) goto 20
        optio2 = zk24(jlisop+iop-1)(1:16)
!
        optdem = .false.
        if (option .eq. optio2) optdem = .true.
!
!       RECUPERATION DE LA LISTE DE NUMERO D'ORDRE
        call codent(iop, 'D0', numopt)
        lisins = nobaop//numopt
        call jeveuo(lisins, 'L', jlinst)
        nbordl = zi(jlinst)
!
!       SI L'OPTION CALCULEE ICI EST DEMANDEE PAR
!       L'UTILISATUER, ON LA MET SUR LA BASE GLOBALE
        basopt = 'G'
        if (optio2 .ne. option) then
            basopt = 'V'
        else
            if( present(base) ) then
                basopt = base
            endif
        endif
!
        if (nbopt .ne. 0) then
            posopt = indk16(zk16(jliopg),optio2,1,nbopt)
            if (posopt .ne. 0) basopt = 'G'
!         CE BLOC A ETE AJOUTE POUR LE CAS OU UNE OPTION1 A DECLENCHE
!         LE CALCUL D'UNE OPTION2 MAIS QUE CETTE OPTION2 EST ENSUITE
!         REDEMANDEE DANS LE MEME CALC_CHAMP PAR L'UTILISATEUR
            if (.not.optdem .and. posopt .ne. 0) zk16(jliopg+posopt-1) = ' '
        endif
!
        if (optdem .and. (nbordl.eq.0)) then
            call utmess('A', 'CALCCHAMP_1', sk=optio2)
        endif
!
! SI PARALLELISME EN TEMPS: EVENTUELLE INITIALISATION CONTEXTE
        if (present(tldist).and.(optio2(6:9) .eq. 'NOEU').and.(nbordl.ge.1)) then
          call pcptcc(101, ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, mpicou,&
                nbordl, nbpas, vldist, vcham, k24b, ibid, k19b,&
                k24b, k8b, lbid,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
          call jeveuo(vldist,'L',jldist)
          if (ldist) call jeveuo(vcham,'E',jvcham)
        else
! SI LA QUESTION NE SE POSE PAS (APPEL RECURSIF CCFNRN > CALCOP OU OPTION ELGA/ELNO)
          call pcptcc(102, ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, mpicou,&
                nbordl, nbpas, vldist, vcham, k24b, ibid, k19b,&
                k24b, k8b, lbid,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
          call jeveuo(vldist,'L',jldist)
        endif
!
! SI PARALLELISME EN TEMPS: ON DEBRANCHE L'EVENTUEL PARALLELISME EN ESPACE
        mode24=' '
        mode24=trim(adjustl(modele))
        call pcptcc(2, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                ibid, ibid, k24b, k24b, k24b, ibid, k19b,&
                mode24, sd_partition, lsdpar,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
    if (nbproc.eq.1) then
        call utmess('I','PREPOST_25',sk=optio2)
    else if (nbproc.gt.1) then
      if (ldist) then
        call utmess('I','PREPOST_22',si=nbordr,sk=optio2)
      else
        if (lsdpar) then
          call utmess('I','PREPOST_23',sk=optio2)
        else
          call utmess('I','PREPOST_24',sk=optio2)
        endif
      endif
    endif
!
        codre2 = 0
        ligrel = ' '
        ligres = ' '
! SI PARALLELISME EN TEMPS: GESTION DE L'INDICE DE DECALAGE
        ipas=1
        lonch=-9999
        do iordr = 1, nbordl
!
! FILTRE POUR EVENTUEL PARALLELISME EN TEMPS
          if (((zi(jldist+iordr-1).eq.rang).and.(ldist)).or.(.not.ldist)) then
! SI PARALLELISME EN TEMPS: CALCUL DES INDICES DE DECALAGE
            call pcptcc(4, ldist, dbg_ob, lbid, lbid, lbid, rang, nbproc, mpibid,&
                   ibid, nbpas, k24b, k24b, k24b, ibid, k19b,&
                   k24b, k8b, lbid,&
                   iordr, ipas, ideb, ifin, irelat,&
                   k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
!
            ligmod = .false.
            numord = zi(jlinst+iordr+2)
!
!         NORDM1 NE SERT QUE POUR ENDO_ELGA
            nordm1 = numord-1
!
            if (optio2(6:9) .eq. 'NOEU') then
!
! VERIFICATION DU CHANGEMENT DE MODELE EVENTUEL
! CONSTRUCTION DU NOM DU CHAM_NO PRODUIT PAR L'OPTION
                if ((ldist).and.(ideb.ne.ifin)) then
! SI PARALLELISME EN TEMPS ET NPAS NON ATTEINT: NBPROC CHAM_NOS SIMULTANES
                  p=1
                  do k=ideb,ifin
                    numork=zi(jlinst+k+2)
                    k8b=' '
                    call medom2(k8b, mater, mateco, carael, lischa, ncharg,&
                              chtype, resuin, numord, nbordr, 'V', npass, ligrel)
                    modnew=' '
                    modnew=trim(adjustl(k8b))
                    if (dbg_ob)&
                      write(ifm,*)'< ',rang,'calcop> modele_avant/modele_apres=',modele,modnew
! CHANGEMENT DE MODELE ENTRE PAS DE TEMPS NON PREVU POUR L'INSTANT
                    if (modele.ne.modnew) then
                      call utmess('F', 'PREPOST_1')
                    else
                      modele=modnew
                    endif
                    call rsexc1(resuou, optio2, numork, nochok)
! CAR CES VARIABLES DOIVENT ETRE CONNUE POUR LE NUMORD COURANT
                    if (numork.eq.numord) then
                      nochou=nochok
                      if (ligres .ne. ligrel) ligmod = .true.
                    endif
                    zk24(jvcham+p-1)=nochok
                    if (dbg_ob) write(ifm,*)'< ',rang,'calcop> p/k/chamnk=',p,k,nochok
                    p=p+1
                  enddo
                  call ccchno(optio2, numord, resuin, resuou, chaout(1:19),&
                            mesmai, nomail, modele, carael, basopt,&
                            ligrel, ligmod, codre2, nochou=nochou,&
                            ideb=ideb, ifin=ifin, vcham=vcham)
                else
! SINON, 1 SEUL A LA FOIS
! SI PARALLELISME EN TEMPS et NPAS ATTEINT (RELIQUAT DE PAS DE TEMPS)
! OU SI NON PARALLELISME EN TEMPS
                  k8b=' '
                  call medom2(k8b, mater, mateco, carael, lischa, ncharg,&
                              chtype, resuin, numord, nbordr, 'V', npass, ligrel)
                  modnew=' '
                  modnew=trim(adjustl(k8b))
! SI PARALLELISME EN TEMPS: CAS DE FIGURE DU RELIQUAT DE PAS DE TEMPS (AU CAS OU)
                  if (ldist) then
                    if (dbg_ob)&
                      write(ifm,*)'< ',rang,'calcop> modele_avant/modele_apres=',modele,modnew
                    if (modele.ne.modnew) call utmess('F', 'PREPOST_1')
                  endif
                  modele=modnew
                  if (ligres .ne. ligrel) ligmod = .true.
                  call rsexc1(resuou, optio2, numord, nochou)
                  call ccchno(optio2, numord, resuin, resuou, chaout(1:19),&
                            mesmai, nomail, modele, carael, basopt,&
                            ligrel, ligmod, codre2, nochou=nochou)
                endif
!
! SI PARALLELISME EN TEMPS:  COM MPI CHAM_NOS.VALE DONT LES NOMS SONT STOCKES DANS VCHAM
                chamno=nochou(1:19)//'.VALE'
                if (ldist) then
                  call dismoi('TYPE_SCA', chamno(1:19), 'CHAM_NO', repk=ktyp)
                  call jelira(chamno, 'LONMAX', lonnew)
! SI PARALLELISME EN TEMPS:
! POUR L'INSTANT, ON SUPPOSE QUE TOUS LES CHAM_NOS SONT DE LONGUEUR IDENTIQUE
! ON TESTE SI C'EST LE CAS SUR LES NBPROCS PAS DE TEMPS CONTIGUES ET SUR LE PAS PRECEDENT
                  call pcptcc(6, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                              ibid, ibid, k24b, k24b, k24b, ibid, k19b,&
                              k24b, k8b, lbid,&
                              ibid, ipas, ibid, ibid, ibid,&
                              k24b, lonnew, lonch, kbid, k24b, prbid, pcbid)
                  lonch=lonnew
                  if (ktyp.eq.'R') then
                    call jeveuo(chamno, 'L', vr=noch)
                  else if (ktyp.eq.'C') then
                    call jeveuo(chamno, 'L', vc=nochc)
                  else
                    ASSERT(.False.)
                  endif
                  if (dbg_ob)&
                      write(ifm,*)'< ',rang,'calcop> chamno/ktyp/lonch=',chamno,ktyp,lonch
                endif
                call pcptcc(7, ldist, dbg_ob, lbid, lbid, lbid, rang, nbproc, mpicou,&
                            ibid, ibid, k24b, vcham, k24b, ibid, k19b,&
                            k24b, k8b, lbid,&
                            ibid, ipas, ideb, ifin, irelat,&
                            k24b, ibid, lonch, ktyp, vcnoch, noch, nochc)
!
! PARALLELISME EN TEMPS: TEST DE VERIFICATION
                call pcptcc(8, ldist, lbid, dbgv_ob, lbid, lbid, ibid, ibid, mpibid,&
                            ibid, ibid, k24b, vcham, k24b, ibid, k19b,&
                            k24b, k8b, lbid,&
                            ibid, ibid, ideb, ifin, ibid,&
                            chamno, ibid, ibid, kbid, k24b, prbid, pcbid)
!
            else if (optio2(6:7).eq.'EL') then
!
                if (option .eq. 'SIRO_ELEM') then
                    call srmedo(modele, mater , mateco, carael, lischa, ncharg,&
                                chtype, resuin, numord, nbordr, basopt,&
                                npass, ligrel)
                else
                    call medom2(modele, mater , mateco, carael, lischa, ncharg,&
                                chtype, resuin, numord, nbordr, basopt,&
                                npass, ligrel)
                endif
!
                call ccchel(optio2, modele, resuin, resuou, numord,&
                            nordm1, mater , mateco, carael, typesd, ligrel,&
                            exipou, exitim, lischa, nbchre, ioccur,&
                            suropt, basopt, chaout)
                if (chaout .eq. ' ') goto 20
!
            endif
!
            call exisd('CHAMP_GD', chaout, iret)
            if (basopt .eq. 'G') then
                if (iret .eq. 0) then
                    codret = 1
                    call utmess('A', 'CALCULEL2_89', sk=optio2)
                else
! POST-TRAITEMENTS
                  if ((ldist).and.(ideb.ne.ifin)) then
! SI PARALLELISME EN TEMPS ET NPAS NON ATTEINT: NBPROC CHAM_NOS SIMULTANES
                    do k=ideb,ifin
                      numork=zi(jlinst+k+2)
                      call rsnoch(resuou, optio2, numork)
                    enddo
                  else
! SI PARALLELISME EN TEMPS et NPAS ATTEINT (RELIQUAT DE PAS DE TEMPS)
! ET SI NON PARALLELISME EN TEMPS
                    call rsnoch(resuou, optio2, numord)
                  endif
                endif
            endif
!
            if (exipou) call jedetc('V', '&&MECHPO', 1)
            call detrsd('CHAM_ELEM_S', chaout)
!
            ligres = ligrel
! SI PARALLELISME EN TEMPS: GESTION DE L'INDICE DE DECALAGE
            if (ldist) ipas=ipas+1
          endif
! FIN DU IF DISTRIBUTION POUR EVENTUEL PARALLELISME EN TEMPS
        end do
!
!
! SI PARALLELISME EN TEMPS: NETTOYAGE DU CONTEXTE
        call pcptcc(301, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                ibid, ibid, vldist, vcham, k24b, ibid, k19b,&
                mode24, sd_partition, lsdpar,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, vcnoch, prbid, pcbid)
 20     continue
    end do
!
    codret = 0
!
!     NETTOYAGE
    call jedetr(nonbor)
    call jedetr(lacalc)
    call ccnett(nobase, nopout)
    if (option(6:9) .eq. 'NOEU' .and. nbma .ne. 0) call jedetr(mesmai)
!
999 continue
!
    call jedema()
!
end subroutine
