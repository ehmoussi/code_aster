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
! aslint: disable=W1501
!
subroutine ccfnrn(option, resuin, resuou, lisord, nbordr,&
                  chtype, typesd)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "blas/dcopy.h"
#include "blas/daxpy.h"
#include "blas/zcopy.h"
#include "blas/zaxpy.h"
#include "asterc/r8vide.h"
#include "asterfort/asasve.h"
#include "asterfort/ascova.h"
#include "asterfort/assert.h"
#include "asterfort/calcop.h"
#include "asterfort/codent.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exlima.h"
#include "asterfort/infniv.h"
#include "asterfort/ischar.h"
#include "asterfort/jeimpo.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerazo.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mcmult.h"
#include "asterfort/memam2.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/nmdome.h"
#include "asterfort/ntdoth.h"
#include "asterfort/numecn.h"
#include "asterfort/pcptcc.h"
#include "asterfort/pteddl.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
#include "asterfort/vecinc.h"
#include "asterfort/vecgme.h"
#include "asterfort/vechme.h"
#include "asterfort/vefnme_cplx.h"
#include "asterfort/vefpme.h"
#include "asterfort/vrcins.h"
#include "asterfort/vtcreb.h"
#include "asterfort/wkvect.h"
#include "asterfort/medome_once.h"
#include "asterfort/verif_bord.h"
#include "asterfort/ascomb.h"
#include "asterfort/dylach.h"
#include "asterfort/lislec.h"
    integer :: nbordr
    character(len=4) :: chtype
    character(len=8) :: resuin, resuou
    character(len=16) :: option, typesd
    character(len=19) :: lisord
!  CALC_CHAMP - CALCUL DES FORCES NODALES ET DES REACTIONS NODALES
!  -    -                  -      -              -         -
! ----------------------------------------------------------------------
    mpi_int :: mpicou, mpibid
    integer :: jordr, iret, iordr, i, jinfc, nbchar, ic, jref, ifm, niv, ibid
    integer :: iachar, ichar, ii, nuord, nh, jnmo, nbddl, lmat, jvPara, ind, iordk
    integer :: neq, jfo, lonch, lonnew, jfr, jfi, rang, nbproc, nbpas, nbordi
    integer :: lonc2, ltrav, j, inume, jddl, jddr, lacce, p, irelat, jordi
    integer :: cret, jldist, iaux1, k, jcnoch, ideb, ifin, ipas, jvcham, iaux2
    character(len=1) :: stop, ktyp, kbid
    character(len=2) :: codret
    character(len=6) :: nompro
    character(len=8) :: k8bid, kiord, ctyp, nomcmp(3), para, sd_partition
    character(len=16) :: typmo, optio2, motfac
    character(len=19) :: ligrel, chdep2, vebid, k19bid, listLoad
    character(len=24) :: numref, fomult, charge, infoch, vechmp, vachmp, cnchmp
    character(len=24) :: vecgmp, vacgmp, cncgmp, vefpip, vafpip, cnfpip, vfono(2)
    character(len=24) :: carac, cnchmpc
    character(len=24) :: vafono, vreno, vareno, sigma, chdepl, valk(3), nume, chdepk, numk
    character(len=24) :: mateco, mater, vafonr, vafoni, k24b, numnew
    character(len=24) :: chvive, chacve, masse, chvarc, compor, k24bid, chamno, chamnk
    character(len=24) :: strx, vldist, vcnoch, vcham, lisori
    character(len=24) :: bidon, chacce, modele, kstr, modnew
    aster_logical :: exitim, lstr, lstr2, ldist, dbg_ob, dbgv_ob, ltest, lsdpar, lcpu, lbid
    aster_logical :: lPilo1, lPilo2
    real(kind=8) :: etan, time, partps(3), omega2, coef(3), raux
    real(kind=8) :: rctfin, rctdeb, rctfini, rctdebi, freq
    real(kind=8), pointer :: cgmp(:) => null()
    real(kind=8), pointer :: chmp(:) => null()
    real(kind=8), pointer :: fono(:) => null()
    real(kind=8), pointer :: fonor(:) => null()
    real(kind=8), pointer :: fonoi(:) => null()
    real(kind=8), pointer :: fpip(:) => null()
    real(kind=8), pointer :: noch(:) => null()
    real(kind=8), pointer :: reno(:) => null()
    real(kind=8), pointer :: nldepl(:) => null()
    complex(kind=8) :: ci, cun, cmun
    complex(kind=8), pointer :: nochc(:) => null()
    complex(kind=8), pointer :: chmpc(:) => null()
    integer, pointer :: v_list_store(:) => null()
    real(kind=8), pointer :: prbid(:) => null()
    complex(kind=8), pointer :: pcbid(:) => null()
    parameter(nompro='CCFNRN')
    data chvarc/'&&CCFNRN.CHVARC'/
    data k24bid/' '/
    data nomcmp/'DX','DY','DZ'/
!
    call jemarq()
!
    call infniv(ifm, niv)
! SI PARALLELISME EN TEMPS: INITIALISATION CONTEXTE
    call pcptcc(1, ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, mpicou,&
                nbordr, nbpas, vldist, vcham, lisori, nbordi, lisord,&
                k24b, k8bid, lbid,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
    call jeveuo(vldist,'L',jldist)
    if (lcpu) call cpu_time(rctdeb)

    lonch=-999
    ci=dcmplx(0.D0,1.D0)
    cun=dcmplx(1.D0,0.D0)
    cmun=dcmplx(-1.D0,0.D0)
!
    bidon='&&'//nompro//'.BIDON'


    listLoad = '&&CCFNRN.LISTLOAD'
!
    call jeveuo(lisord, 'L', jordr)
!
! ----ON VERIFIE SI DERRIERE UN CONCEPT MODE_MECA SE TROUVE UN MODE_DYN
    if (typesd(1:9) .eq. 'MODE_MECA') then
        call rsadpa(resuin, 'L', 1, 'TYPE_MODE', 1, 0, sjv=jvPara, styp=k8bid)
        typmo=zk16(jvPara)
    else
        typmo=' '
    endif
!
! - Only one list of loads for REAC_NODA
!
    if (option .eq. 'REAC_NODA' .and. &
        (typesd .eq. 'EVOL_ELAS' .or. typesd .eq. 'EVOL_NOLI')) then
        call jeveuo(lisord, 'L', vi = v_list_store)
        call medome_once(resuin, v_list_store, nbordr)
    endif

!
! TRI DES OPTIONS SUIVANT TYPESD
    lmat=0
    exitim=.false.
    if (typesd .eq. 'EVOL_ELAS' .or. typesd .eq. 'EVOL_NOLI') then
        exitim=.true.
    else if (typesd.eq.'MODE_MECA' .or. typesd.eq.'DYNA_TRANS') then
        call jeexin(resuin//'           .REFD', iret)
        if (iret .ne. 0) then
            call dismoi('REF_MASS_PREM', resuin, 'RESU_DYNA', repk=masse, arret='C')
            if (masse .ne. ' ') then
                call mtdscr(masse)
                call jeveuo(masse(1:19)//'.&INT', 'E', lmat)
            endif
        endif
        if (typesd .eq. 'DYNA_TRANS') exitim=.true.
    else if (typesd.eq.'DYNA_HARMO') then
        call jeexin(resuin//'           .REFD', iret)
        if (iret .ne. 0) then
            call dismoi('REF_MASS_PREM', resuin, 'RESU_DYNA', repk=masse, arret='C')
            if (masse .ne. ' ') then
                call mtdscr(masse)
                call jeveuo(masse(1:19)//'.&INT', 'E', lmat)
            endif
        endif
    endif
    if (typesd .eq. 'MODE_MECA' .or. typesd .eq. 'DYNA_TRANS') then
        call dismoi('NUME_DDL', resuin, 'RESU_DYNA', repk=numref)
    endif
    carac=' '
    charge=' '
    mateco=' '
    mater=' '
    modele=' '
    nuord=zi(jordr)
    k24b=' '
    if (typesd .eq. 'EVOL_THER') then
        call ntdoth(k24b, mater, mateco, carac, listLoad,&
                    result = resuou, nume_store = nuord)
    else
        call nmdome(k24b, mater, mateco, carac, listLoad, resuou(1:8),&
                    nuord)
    endif
    modele=' '
    modele=trim(adjustl(k24b))
    if (modele(1:2) .eq. '&&') call utmess('F', 'CALCULEL3_50')
!
! SI PARALLELISME EN TEMPS: ON DEBRANCHE L'EVENTUEL PARALLELISME EN ESPACE
    call pcptcc(2, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                ibid, ibid, k24b, k24b, k24b, ibid, k19bid,&
                modele, sd_partition, lsdpar,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
    if (nbproc.eq.1 .and. niv >1) then
        call utmess('I','PREPOST_25',sk=option)
    else if (nbproc.gt.1) then
      if (ldist) then
        call utmess('I','PREPOST_22',si=nbordr,sk=option)
      else
        if (lsdpar) then
          call utmess('I','PREPOST_23',sk=option)
        else
          call utmess('I','PREPOST_24',sk=option)
        endif
      endif
    endif
!
    fomult=listLoad//'.FCHA'
    charge=listLoad//'.LCHA'
    infoch=listLoad//'.INFC'
    call jeexin(infoch, iret)
    if (iret .ne. 0) then
        call jeveuo(infoch, 'L', jinfc)
        nbchar=zi(jinfc)
        if (nbchar .ne. 0) then
            call jeveuo(charge, 'L', iachar)
            call jedetr('&&'//nompro//'.L_CHARGE')
            call wkvect('&&'//nompro//'.L_CHARGE', 'V V K8', nbchar, ichar)
            do ii = 1, nbchar
                zk8(ichar-1+ii)=zk24(iachar-1+ii)(1:8)
            enddo
        else
            ichar=1
        endif
    else
        nbchar=0
        ichar=1
    endif
    call exlima(' ', 0, 'V', modele, ligrel)
! ON REGARDE S'IL Y A DES ELEMENTS DE STRUCTURE UTILISANT LE CHAMP STRX_ELGA
    strx=' '
    call dismoi('EXI_STRX', modele, 'MODELE', repk=kstr)
    lstr=(kstr(1:3).eq.'OUI')
! Y A-T-IL DES ELEMENTS SACHANT CALCULER L'OPTION STRX_ELGA
    call dismoi('EXI_STR2', modele, 'MODELE', repk=kstr)
    lstr2=(kstr(1:3).eq.'OUI')
!
!
    if (lcpu) then
      call cpu_time(rctfin)
      write(ifm,*)'< ',rang,'ccfnrn> Preparation_CPU=',rctfin-rctdeb
    endif
    time=0.d0
! SI PARALLELISME EN TEMPS: GESTION DE L'INDICE DE DECALAGE
    ipas=1
    nume=' '
    lonch=-999
    do i = 1, nbordr
      if (lcpu) call cpu_time(rctdebi)
!
! FILTRE POUR EVENTUEL PARALLELISME EN TEMPS
      if (((zi(jldist+i-1).eq.rang).and.(ldist)).or.(.not.ldist)) then
        call jemarq()

! SI PARALLELISME EN TEMPS: RECHARGE ADRESSES JEVEUX A CAUSE DU JEMARQ/JEDEMA LOCAL
        if (ldist) then
          call jeveuo(vcham,'E',jvcham)
          call jeveuo(lisori,'L',jordi)
          if (ipas.gt.1) call jeveuo(vcnoch,'E',jcnoch)
        endif
! SI PARALLELISME EN TEMPS: CALCUL DES INDICES DE DECALAGE
        call pcptcc(4, ldist, dbg_ob, lbid, lbid, lbid, rang, nbproc, mpibid,&
                   ibid, nbpas, k24b, k24b, k24b, ibid, k19bid,&
                   k24b, k8bid, lbid,&
                   i, ipas, ideb, ifin, irelat,&
                   k24b, ibid, ibid, kbid, k24b, prbid, pcbid)
        if (lcpu) call cpu_time(rctdeb)
!
        iordr=zi(jordr+i-1)
!
        vechmp=' '
        vachmp=' '
        cnchmp=' '
        vecgmp=' '
        vacgmp=' '
        cncgmp=' '
        vefpip=' '
        vafpip=' '
        cnfpip=' '
        etan=0.d0
        vfono(1)=' '
        vfono(2)=' '
        vafono=' '
        vafonr=' '
        vafoni=' '
        vreno='&&'//nompro//'           .RELR'
        vareno='&&'//nompro//'           .RELR'
!
        nh=0
        if (typesd(1:8) .eq. 'FOURIER_') then
            call rsadpa(resuin, 'L', 1, 'NUME_MODE', iordr, 0, sjv=jnmo)
            nh=zi(jnmo)
        endif
        call rsexch(' ', resuin, 'SIEF_ELGA', iordr, sigma, iret)
        if (iret .ne. 0) then
          optio2 = 'SIEF_ELGA'
          if (ldist) then
            call calcop(optio2, ' ', resuin, resuou, lisori, nbordi, chtype, typesd, cret, 'V')
          else
            call calcop(optio2, ' ', resuin, resuou, lisord, nbordr, chtype, typesd, cret, 'V')
          endif
        endif
        if (lstr) then
          call rsexch(' ', resuin, 'STRX_ELGA', iordr, strx, iret)
          if (iret .ne. 0 .and. lstr2) then
            optio2 = 'STRX_ELGA'
            if (ldist) then
              call calcop(optio2, ' ', resuin, resuou, lisori, nbordi, chtype, typesd, cret, 'V')
            else
              call calcop(optio2, ' ', resuin, resuou, lisord, nbordr, chtype, typesd, cret, 'V')
            endif
         endif
        endif
!
        call rsexch(' ', resuin, 'DEPL', iordr, chdepl, iret)
        if (iret .ne. 0) then
            call codent(iordr, 'G', kiord)
            valk(1)=kiord
            valk(2)=option
            call utmess('A', 'PREPOST5_3', nk=2, valk=valk)
            goto 280
!
        else
!
!         CREATION D'UN VECTEUR ACCROISSEMENT DE DEPLACEMENT NUL
!         POUR LE CALCUL DE FORC_NODA DANS LES POU_D_T_GD
            chdep2='&&'//nompro//'.CHDEP_NUL'
            call copisd('CHAMP_GD', 'V', chdepl, chdep2)
            call jelira(chdep2//'.VALE', 'LONMAX', nbddl)
            call jerazo(chdep2//'.VALE', nbddl, 1)
        endif
!
!       -- CALCUL D'UN NUME_DDL "MINIMUM" POUR ASASVE :
        if (typesd .eq. 'MODE_MECA' .or. typesd .eq. 'DYNA_TRANS') then
! NUME_DDL QUI NE CHANGE PAS AVEC LE PAS DE TEMPS: NUME
            nume=numref(1:14)//'.NUME'
        else
! NUME_DDL QUI PEUT CHANGER AVEC LE PAS DE TEMPS: DONC ON TESTE CET EVENTUEL CHANGEMENT
! SI PARALLELISME EN TEMPS ACTIVE ET PAS DE TEMPS PARALLELISES: NUME
          k24b=' '
          call numecn(modele, chdepl, k24b)
          numnew=' '
          numnew=trim(adjustl(k24b))
          if ((ldist).and.(ideb.ne.ifin)) then
! SI PARALLELISME EN TEMPS ET NPAS NON ATTEINT: NBPROC CHAM_NOS SIMULTANES
            do k=ideb,ifin
              iordk=zi(jordr+k-1)
              chdepk=' '
              call rsexch(' ', resuin, 'DEPL', iordk, chdepk, iret)
              k24b=' '
              call numecn(modele, chdepk, k24b)
              numk=' '
              numk=trim(adjustl(k24b))
              if (dbg_ob)&
                write(ifm,*)'< ',rang,'ccfnrn> numeddl_avant/numddl_apres=',numnew,numk
              if (numnew.ne.numk) call utmess('F', 'PREPOST_16')
            enddo
          else
! SI PARALLELISME EN TEMPS et NPAS ATTEINT (RELIQUAT DE PAS DE TEMPS)
! ET SI NON PARALLELISME EN TEMPS
            if (ldist) then
              if (dbg_ob)&
                write(ifm,*)'< ',rang,'ccfnrn> numeddl_avant/numddl_apres=',nume,numnew
              if (nume.ne.numnew) call utmess('F', 'PREPOST_16')
            endif
          endif
          nume=' '
          nume=numnew
        endif
!
        call rsexch(' ', resuin, 'VITE', iordr, chvive, iret)
        if (iret .eq. 0) then
            chvive='&&'//nompro//'.CHVIT_NUL'
            call copisd('CHAMP_GD', 'V', chdepl, chvive)
            call jelira(chvive(1:19)//'.VALE', 'LONMAX', nbddl)
            call jerazo(chvive(1:19)//'.VALE', nbddl, 1)
        endif
        call rsexch(' ', resuin, 'ACCE', iordr, chacve, iret)
        if (iret .eq. 0) then
            chacve='&&'//nompro//'.CHACC_NUL'
            call copisd('CHAMP_GD', 'V', chdepl, chacve)
            call jelira(chacve(1:19)//'.VALE', 'LONMAX', nbddl)
            call jerazo(chacve(1:19)//'.VALE', nbddl, 1)
        endif
!
        if (exitim) then
            call rsadpa(resuin, 'L', 1, 'INST', iordr,0, sjv=jvPara, styp=ctyp)
            time=zr(jvPara)
        endif
!
        call vrcins(modele, mater, carac, time, chvarc(1:19), codret)
        call rsexch(' ', resuin, 'COMPORTEMENT', iordr, compor, iret)
!
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step1_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
! Initialisation
        partps(1) = time
        partps(2) = time
        partps(3) = 0.D0
!
!
! separation reel imag si dyna_harmo
        call vefnme_cplx(option, 'V', modele, mateco, carac,&
                    compor, partps, nh, ligrel, chvarc,&
                    sigma, strx, chdepl, chdep2, vfono)
!       --- ASSEMBLAGE DES VECTEURS ELEMENTAIRES ---
        if (typesd.ne.'DYNA_HARMO') then
            call asasve(vfono(1), nume, 'R', vafono)
        else
! creation champ aux noeuds
            call vtcreb(vfono(1), 'V', 'R', nume_ddlz = nume)
            call asasve(vfono(1), nume, 'R', vafonr)
            call vtcreb(vfono(2), 'V', 'R', nume_ddlz = nume)
            call asasve(vfono(2), nume, 'R', vafoni)
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step2_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!       --- CREATION DE LA STRUCTURE CHAM_NO ---
        if ((ldist).and.(ideb.ne.ifin)) then
! SI PARALLELISME EN TEMPS ET NPAS NON ATTEINT: NBPROC CHAM_NOS SIMULTANES
          p=1
          do k=ideb,ifin
            iordk=zi(jordr+k-1)
            call rsexch(' ', resuou, option, iordk, chamnk, iret)
! CAR LA VARIABLE CHAMNO DOIT ETRE CONNUE POUR L'IORDR COURANT
            if (iordk.eq.iordr) chamno=chamnk
! ON DOIT PRENDRE LES MEMES DECISIONS QU'EN SEQUENTIEL: NETTOYAGE, MSG...
            call jeexin(chamnk(1:19)//'.REFE', iret)
            if (iret .ne. 0) then
              call codent(iordk, 'G', kiord)
              valk(1)=option
              valk(2)=kiord
              call utmess('A', 'PREPOST5_1', nk=2, valk=valk)
              call detrsd('CHAM_NO', chamnk(1:19))
            endif
            zk24(jvcham+p-1)=' '
            zk24(jvcham+p-1)=chamnk
            if (dbg_ob) write(ifm,*)'< ',rang,'ccfnrn> p/k/chamnk=',p,k,chamnk
            p=p+1
          enddo
        else
! SINON, 1 SEUL A LA FOIS
! SI PARALLELISME EN TEMPS et NPAS ATTEINT (RELIQUAT DE PAS DE TEMPS)
! OU SI NON PARALLELISME EN TEMPS
          call rsexch(' ', resuou, option, iordr, chamno, iret)
          call jeexin(chamno(1:19)//'.REFE', iret)
          if (iret .ne. 0) then
            call codent(iordr, 'G', kiord)
            valk(1)=option
            valk(2)=kiord
            call utmess('A', 'PREPOST5_1', nk=2, valk=valk)
            call detrsd('CHAM_NO', chamno(1:19))
          endif
        endif
!
! CREATION DES SDS CHAM_NOS SIMPLE OU SIMULTANES
        if (typesd.ne.'DYNA_HARMO') then
            ktyp='R'
            if ((ldist).and.(ideb.ne.ifin)) then
              call vtcreb(chamno,'G','R',nume_ddlz=nume,nb_equa_outz=neq,nbz=nbproc,vchamz=vcham)
            else
              call vtcreb(chamno, 'G', 'R', nume_ddlz = nume, nb_equa_outz = neq)
            endif
            call jeveuo(chamno(1:19)//'.VALE', 'E', vr=noch)
        else
            ktyp='C'
            if ((ldist).and.(ideb.ne.ifin)) then
              call vtcreb(chamno,'G','C',nume_ddlz=nume,nb_equa_outz=neq,nbz=nbproc,vchamz=vcham)
            else
              call vtcreb(chamno, 'G', 'C', nume_ddlz = nume, nb_equa_outz = neq)
            endif
            call jeveuo(chamno(1:19)//'.VALE', 'E', vc=nochc)
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step3_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
!       --- REMPLISSAGE DE L'OBJET .VALE DU CHAM_NO ---
        call jelira(chamno(1:19)//'.VALE', 'LONMAX', lonnew)
! SI PARALLELISME EN TEMPS:
! POUR L'INSTANT, ON SUPPOSE QUE TOUS LES CHAM_NOS SONT DE LONGUEUR IDENTIQUE
! ON TESTE SI C'EST LE CAS SUR LES NBPROCS PAS DE TEMPS CONTIGUES ET SUR LE PAS PRECEDENT
        call pcptcc(6, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                   ibid, ibid, k24b, k24b, k24b, ibid, k19bid,&
                   k24b, k8bid, lbid,&
                   ibid, ipas, ibid, ibid, ibid,&
                   k24b, lonnew, lonch, kbid, k24b, prbid, pcbid)
        lonch=lonnew
!
        if (typesd.ne.'DYNA_HARMO') then
            call jeveuo(vafono, 'L', jfo)
            call jeveuo(zk24(jfo)(1:19)//'.VALE', 'L', vr=fono)
        else
            call jeveuo(vafonr, 'L', jfr)
            call jeveuo(zk24(jfr)(1:19)//'.VALE', 'L', vr=fonor)
            call jeveuo(vafoni, 'L', jfi)
            call jeveuo(zk24(jfi)(1:19)//'.VALE', 'L', vr=fonoi)
            do j = 0, lonch-1
                nochc(1+j)=dcmplx(fonor(1+j),fonoi(1+j))
            end do
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step4_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
!       --- STOCKAGE DES FORCES NODALES ---
        if (option .eq. 'FORC_NODA') then
          if (typesd.ne.'DYNA_HARMO') call dcopy(lonch,fono,1,noch,1)
          goto 270
        endif
!
!       --- CALCUL DES FORCES NODALES DE REACTION

        if (charge .ne. ' ') then
            partps(1)=time
!
! --- CHARGES NON PILOTEES (TYPE_CHARGE: 'FIXE_CSTE')
! --- SI LDIST, ON NE VERIFIE QU'AU PREMIER PAS
          if ((.not.ldist).or.(ldist.and.(ipas.eq.1))) then
            if (ligrel(1:8) .ne. modele) then
                stop = 'C'
!               -- on verifie que le ligrel contient bien les mailles de bord
                call verif_bord(modele,ligrel)
            else
                stop = 'S'
            endif
          endif
!
            if (typesd.ne.'DYNA_HARMO') then
                call vechme(stop, modele, charge, infoch, partps,&
                        carac, mater, mateco, vechmp, varc_currz = chvarc, ligrel_calcz = ligrel,&
                        nharm = nh)
                call asasve(vechmp, nume, 'R', vachmp)
                call ascova('D', vachmp, fomult, 'INST', time, 'R', cnchmp)
!
! --- CHARGES SUIVEUSE (TYPE_CHARGE: 'SUIV')
                call detrsd('CHAMP_GD', bidon)
                call vtcreb(bidon, 'G', 'R', nume_ddlz = nume, nb_equa_outz = neq)
                call vecgme(modele,carac,mater,mateco,charge,infoch,partps(1),chdepl,&
                        bidon,vecgmp,partps(1),compor,ligrel,chvive,chacve,strx)
                call asasve(vecgmp, nume, 'R', vacgmp)
                call ascova('D', vacgmp, fomult, 'INST', time, 'R', cncgmp)
            else
                call rsadpa(resuin, 'L', 1, 'FREQ', iordr,0, sjv=jvPara, styp=ctyp)
                freq=zr(jvPara)
                if (ligrel(1:8) .ne. modele) then
!pour les DYNA_HARMO
!pour l instant je ne fais le calcul de REAC_NODA que sur le modele en entier
!(gestion FONC_MULT_C : fastidieuse)
                    call utmess('F', 'PREPOST3_96')
                endif
                motfac = 'EXCIT'
                if ((.not.ldist.and.(i.eq.1)).or.(ldist.and.(ipas.eq.1))) then
                  call lislec(motfac, 'MECANIQUE', 'V', listLoad)
                else
                  call jedetr(cnchmpc(1:19)//'.REFE')
                  call jedetr(cnchmpc(1:19)//'.DESC')
                  call jedetr(cnchmpc(1:19)//'.VALE')
                endif
                vebid = '&&VEBIDON'
                vechmp = '&&VECHMP'
                call dylach(modele, mater, mateco, carac,&
                            listLoad, nume, vebid, vechmp, vebid, vebid)
                para = 'FREQ'
                cnchmpc='&&'//nompro//'.CHARGE'
                call vtcreb(cnchmpc, 'V', 'C', nume_ddlz = nume, nb_equa_outz = neq)
                call ascomb(listLoad, vechmp, 'C', para, freq, cnchmpc)
            endif


!
! --- POUR UN EVOL_NOLI, PRISE EN COMPTE DES FORCES PILOTEES
            if (typesd .eq. 'EVOL_NOLI') then
! - CHARGES PILOTEES (TYPE_CHARGE: 'FIXE_PILO')
                call vefpme(modele, carac, mater, mateco, charge, infoch,&
                            partps, k24bid, vefpip, ligrel, chdepl, bidon)
                call asasve(vefpip, nume, 'R', vafpip)
                call ascova('D', vafpip, fomult, 'INST', time, 'R', cnfpip)

! ------------- Loads with continuation method
                lPilo1 = ischar(listLoad, 'DIRI', 'PILO')
                lPilo2 = ischar(listLoad, 'NEUM', 'PILO')
                if (lPilo1 .or. lPilo2) then
                    call rsadpa(resuin, 'L', 1, 'ETA_PILOTAGE', iordr, 0, sjv=jvPara, istop=0)
                    etan = zr(jvPara)
                    if (etan .eq. r8vide()) then
                        call utmess('F', 'CALCCHAMP_8')
                    endif
                else
                    etan = 0.d0
                endif
            endif
!
! --- CALCUL DU CHAMNO DE REACTION PAR DIFFERENCE DES FORCES NODALES
! --- ET DES FORCES EXTERIEURES MECANIQUES NON SUIVEUSES
            if (typesd.ne.'DYNA_HARMO') then
                call jeveuo(cnchmp(1:19)//'.VALE', 'L', vr=chmp)
                call jeveuo(cncgmp(1:19)//'.VALE', 'L', vr=cgmp)
            else
                call jeveuo(cnchmpc(1:19)//'.VALE', 'L', vc=chmpc)
            endif
            if (typesd.ne.'DYNA_HARMO') then
              do j = 0, lonch-1
                noch(1+j)=fono(1+j)-chmp(1+j)-cgmp(1+j)
              enddo
            else
              call zaxpy(lonch,cmun,chmpc,1,nochc,1)
            endif
            if (typesd.eq.'EVOL_NOLI') then
                call jeveuo(cnfpip(1:19)//'.VALE', 'L', vr=fpip)
                call daxpy(lonch,-1.d0*etan,fpip,1,noch,1)
            endif
        else
!         --- CALCUL DU CHAMNO DE REACTION PAR RECOPIE DE FORC_NODA
            if (typesd.ne.'DYNA_HARMO') call dcopy(lonch,fono,1,noch,1)
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step5_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
!       --- TRAITEMENT DES MODE_MECA ---
        if (typesd .eq. 'MODE_MECA' .and. typmo(1:8) .eq. 'MODE_DYN') then
            call rsadpa(resuin, 'L', 1, 'OMEGA2', iordr, 0, sjv=jvPara, styp=ctyp)
            omega2=zr(jvPara)
            call jeveuo(chdepl(1:19)//'.VALE', 'L', vr=nldepl)
            call jelira(chdepl(1:19)//'.VALE', 'LONMAX', lonc2)
            call wkvect('&&'//nompro//'.TRAV', 'V V R', lonc2, ltrav)
            if (lmat .eq. 0) call utmess('F', 'PREPOST3_81', sk=option)
            call mrmult('ZERO', lmat, nldepl, zr(ltrav), 1, .true._1)
            call daxpy(lonch,-1.d0*omega2,zr(ltrav),1,noch,1)
            call jedetr('&&'//nompro//'.TRAV')
!
!       --- TRAITEMENT DES MODE_STAT ---
        elseif (typesd.eq.'MODE_MECA' .and. typmo(1:8).eq.'MODE_STA') then
            call rsadpa(resuin, 'L', 1, 'TYPE_DEFO', iordr, 0, sjv=jvPara, styp=ctyp)
            if (zk16(jvPara)(1:9) .eq. 'FORC_IMPO') then
                call rsadpa(resuin, 'L', 1, 'NUME_DDL', iordr, 0, sjv=jvPara, styp=ctyp)
                inume=zi(jvPara)
                noch(inume)=noch(inume)-1.d0
            else if (zk16(jvPara)(1:9).eq.'ACCE_IMPO') then
                call jelira(chdepl(1:19)//'.VALE', 'LONMAX', lonc2)
                call rsadpa(resuin, 'L', 1, 'COEF_X', iordr, 0, sjv=jvPara, styp=ctyp)
                coef(1)=zr(jvPara)
                call rsadpa(resuin, 'L', 1, 'COEF_Y', iordr, 0, sjv=jvPara, styp=ctyp)
                coef(2)=zr(jvPara)
                call rsadpa(resuin, 'L', 1, 'COEF_Z', iordr, 0, sjv=jvPara, styp=ctyp)
                coef(3)=zr(jvPara)
                call wkvect('&&'//nompro//'.POSI_DDL', 'V V I', 3*lonc2, jddl)
                call pteddl('NUME_DDL', nume, 3, nomcmp, lonc2, tabl_equa = zi(jddl))
                call wkvect('&&'//nompro//'.POSI_DDR', 'V V R', lonc2, jddr)
                iaux1=lonc2-1
                iaux2=jddl+ind
                do ic = 1, 3
                    ind=lonc2*(ic-1)
                    raux=coef(ic)
                    do j = 0, iaux1
                        zr(jddr+j)=zr(jddr+j)+zi(jddl+ind+j)*raux
                    enddo
                end do
                call wkvect('&&'//nompro//'.TRAV', 'V V R', lonc2, ltrav)
                if (lmat .eq. 0) call utmess('F', 'PREPOST3_81', sk=option)
                call mrmult('ZERO', lmat, zr(jddr), zr(ltrav), 1, .true._1)
                call daxpy(lonch,-1.d0,zr(ltrav),1,noch,1)
                call jedetr('&&'//nompro//'.POSI_DDR')
                call jedetr('&&'//nompro//'.POSI_DDL')
                call jedetr('&&'//nompro//'.TRAV')
            endif
!
!       --- TRAITEMENT DE DYNA_TRANS ---
        else if (typesd.eq.'DYNA_TRANS') then
            call rsexch(' ', resuin, 'ACCE', iordr, chacce,iret)
            if (iret .eq. 0) then
                call jeveuo(chacce(1:19)//'.VALE', 'L', lacce)
                call wkvect('&&'//nompro//'.TRAV', 'V V R', lonch, ltrav)
                if (lmat .eq. 0) call utmess('F', 'PREPOST3_81', sk=option)
                call mrmult('ZERO', lmat, zr(lacce), zr(ltrav), 1, .true._1)
                call daxpy(lonch,1.d0,zr(ltrav),1,noch,1)
                call jedetr('&&'//nompro//'.TRAV')
            else
                call utmess('A', 'CALCULEL3_1')
            endif
!
!       --- TRAITEMENT DE DYNA_HARMO ---
        else if (typesd.eq.'DYNA_HARMO') then
            call rsexch(' ', resuin, 'ACCE', iordr, chacce,iret)
            if (iret .eq. 0) then
                call jeveuo(chacce(1:19)//'.VALE', 'L', lacce)
                call wkvect('&&'//nompro//'.TRAV', 'V V C', lonch, ltrav)
                if (lmat .eq. 0) call utmess('F', 'PREPOST3_81', sk=option)
                call mcmult('ZERO', lmat, zc(lacce), zc(ltrav), 1, .true._1)
                call zaxpy(lonch,cun,zc(ltrav),1,nochc,1)
                call jedetr('&&'//nompro//'.TRAV')
            else
                call utmess('A', 'CALCULEL3_1')
            endif
!
!       --- TRAITEMENT DE EVOL_NOLI ---
        else if (typesd.eq.'EVOL_NOLI') then
            call rsexch(' ', resuin, 'ACCE', iordr, chacce, iret)
            if (iret .eq. 0) then
                optio2='M_GAMMA'
!
!           --- CALCUL DES MATRICES ELEMENTAIRES DE MASSE
                call memam2(optio2, modele, mater, mateco,&
                            carac, compor, time, chacce,&
                            vreno, 'V', ligrel)
!
!           --- ASSEMBLAGE DES VECTEURS ELEMENTAIRES ---
                call asasve(vreno, nume, 'R', vareno)
                call jeveuo(vareno, 'L', jref)
                call jeveuo(zk24(jref)(1:19)//'.VALE', 'L', vr=reno)
                call daxpy(lonch,1.d0,reno,1,noch,1)
            endif
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step6_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
270     continue
!
! SI PARALLELISME EN TEMPS: ACTIVATION TEST CANONIQUE POUR VERIFIER COM MPI
        if (ltest) then
          if (ktyp.eq.'R') then
            call vecini(lonch,(iordr)*1.d0,noch)
          else if (ktyp.eq.'C') then
            call vecinc(lonch,(iordr)*ci,nochc)
          else
            ASSERT(.False.)
          endif
        endif
! SI PARALLELISME EN TEMPS:  COM MPI CHAM_NOS.VALE DONT LES NOMS SONT STOCKES DANS VCHAM
        call pcptcc(7, ldist, dbg_ob, lbid, lbid, lbid, rang, nbproc, mpicou,&
                   ibid, ibid, k24b, vcham, k24b, ibid, k19bid,&
                   k24b, k8bid, lbid,&
                   ibid, ipas, ideb, ifin, irelat,&
                   k24b, ibid, lonch, ktyp, vcnoch, noch, nochc)
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step7_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
! POST-TRAITEMENTS
        if ((ldist).and.(ideb.ne.ifin)) then
! SI PARALLELISME EN TEMPS ET NPAS NON ATTEINT: NBPROC CHAM_NOS SIMULTANES
          do k=ideb,ifin
            iordk=zi(jordr+k-1)
            call rsnoch(resuou, option, iordk)
            k24b=' '
            if (typesd .eq. 'EVOL_THER') then
              call ntdoth(k24b,mater,mateco,carac,listLoad,result=resuou,nume_store =iordk)
            else
              call nmdome(k24b,mater,mateco,carac,listLoad,resuou(1:8),iordk)
            endif
            modnew=' '
            modnew=trim(adjustl(k24b))
            if (dbg_ob)&
              write(ifm,*)'< ',rang,'ccfnrn> modele_avant/modele_apres=',modele,modnew
            if (modele.ne.modnew) then
              call utmess('F', 'PREPOST_1')
            else
              modele=modnew
            endif
          enddo
        else
! EN SIMPLE
! SI PARALLELISME EN TEMPS et NPAS ATTEINT (RELIQUAT DE PAS DE TEMPS)
! ET SI NON PARALLELISME EN TEMPS
          call rsnoch(resuou, option, iordr)
          k24b=' '
          if (typesd .eq. 'EVOL_THER') then
            call ntdoth(k24b,mater,mateco,carac,listLoad,result=resuou,nume_store=iordr)
          else
            call nmdome(k24b,mater,mateco,carac,listLoad,resuou(1:8),iordr)
          endif
          modnew=' '
          modnew=trim(adjustl(k24b))
! CAS DE FIGURE DU RELIQUAT DE PAS DE TEMPS
          if (ldist) then
            if (dbg_ob)&
            write(ifm,*)'< ',rang,'ccfnrn> modele_avant/modele_apres=',modele,modnew
            if (modele.ne.modnew) call utmess('F', 'PREPOST_1')
         endif
          modele=modnew
        endif
        if (lcpu) then
          call cpu_time(rctfin)
          write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' step8_CPU=',rctfin-rctdeb
          call cpu_time(rctdeb)
        endif
!
! PARALLELISME EN TEMPS: TEST DE VERIFICATION
        call pcptcc(8, ldist, lbid, dbgv_ob, lbid, lbid, ibid, ibid, mpibid,&
                  ibid, ibid, k24b, vcham, k24b, ibid, k19bid,&
                  k24b, k8bid, lbid,&
                  ibid, ibid, ideb, ifin, ibid,&
                  chamno, ibid, ibid, kbid, k24b, prbid, pcbid)
!
        call detrsd('CHAMP_GD', '&&'//nompro//'.SIEF')
        call detrsd('VECT_ELEM', vfono(1)(1:8))
        call detrsd('VECT_ELEM', vfono(2)(1:8))
        call detrsd('VECT_ELEM', vreno(1:8))
        call detrsd('VECT_ELEM', vechmp(1:8))
        call detrsd('VECT_ELEM', vecgmp(1:8))
        call detrsd('VECT_ELEM', vefpip(1:8))
        call detrsd('CHAMP_GD', cnchmp(1:8)//'.ASCOVA')
        call detrsd('CHAMP_GD', cncgmp(1:8)//'.ASCOVA')
        call detrsd('CHAMP_GD', cnfpip(1:8)//'.ASCOVA')
        call jedetr(vachmp(1:8))
        call jedetr(vacgmp(1:8))
        call jedetr(vafpip(1:8))
        call jedetr(vachmp(1:6)//'00.BIDON')
        call jedetr(vacgmp(1:6)//'00.BIDON')
        call jedetr(vafpip(1:6)//'00.BIDON')
        call jedetr(vachmp(1:6)//'00.BIDON     .VALE')
        call jedetr(vacgmp(1:6)//'00.BIDON     .VALE')
        call jedetr(vafpip(1:6)//'00.BIDON     .VALE')
        call jedetr(vachmp(1:6)//'00.BIDON     .DESC')
        call jedetr(vacgmp(1:6)//'00.BIDON     .DESC')
        call jedetr(vafpip(1:6)//'00.BIDON     .DESC')
        call jedetr(vachmp(1:6)//'00.BIDON     .REFE')
        call jedetr(vacgmp(1:6)//'00.BIDON     .REFE')
        call jedetr(vafpip(1:6)//'00.BIDON     .REFE')
        call jedetr(vfono(1)(1:8)//'           .REFE')
        call jedetr(vfono(2)(1:8)//'           .REFE')
        call jedetr(vfono(1)(1:8)//'           .DESC')
        call jedetr(vfono(2)(1:8)//'           .VALE')
        call jedetr(vfono(1)(1:8)//'           .VALE')
        call jedetr(vfono(2)(1:8)//'           .DESC')
        call jedetr(vachmp(1:8)//'.ASCOVA')
        call jedetr(vacgmp(1:8)//'.ASCOVA')
        call jedetr(vafpip(1:8)//'.ASCOVA')
280     continue
! SI PARALLELISME EN TEMPS: GESTION DE L'INDICE DE DECALAGE
        if (ldist) ipas=ipas+1
!
        call jedema()
      endif
! FIN DU IF DISTRIBUTION POUR EVENTUEL PARALLELISME EN TEMPS
!
      if (lcpu) then
        call cpu_time(rctfini)
        write(ifm,*)'< ',rang,'ccfnrn> Boucle i=',i,' total_CPU=',rctfini-rctdebi
      endif
    end do
    call detrsd('CHAMP_GD', bidon)
!
! SI PARALLELISME EN TEMPS: NETTOYAGE DU CONTEXTE
    call pcptcc(3, ldist, dbg_ob, lbid, lbid, lbid, rang, ibid, mpibid,&
                ibid, ibid, vldist, vcham, lisori, ibid, k19bid,&
                modele, sd_partition, lsdpar,&
                ibid, ibid, ibid, ibid, ibid,&
                k24b, ibid, ibid, kbid, vcnoch, prbid, pcbid)
!
    call jedema()
end subroutine
