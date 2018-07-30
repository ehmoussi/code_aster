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
! aslint: disable=W1501
!
subroutine comdlh()
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/etausr.h"
#include "asterc/gcucon.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterc/r8depi.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/cresol.h"
#include "asterfort/dismoi.h"
#include "asterfort/dy2mbr.h"
#include "asterfort/dydome.h"
#include "asterfort/dyexre.h"
#include "asterfort/dylach.h"
#include "asterfort/dylech.h"
#include "asterfort/dylema.h"
#include "asterfort/extdia.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mdallo.h"
#include "asterfort/mdarch.h"
#include "asterfort/mgutdm.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/mtdefs.h"
#include "asterfort/mtdscr.h"
#include "asterfort/omega2.h"
#include "asterfort/preres.h"
#include "asterfort/refdaj.h"
#include "asterfort/resoud.h"
#include "asterfort/resu60.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsorac.h"
#include "asterfort/sigusr.h"
#include "asterfort/titre.h"
#include "asterfort/utcrre.h"
#include "asterfort/utmess.h"
#include "asterfort/uttcpr.h"
#include "asterfort/uttcpu.h"
#include "asterfort/vecinc.h"
#include "asterfort/vtcrem.h"
#include "asterfort/wkvect.h"
#include "blas/zcopy.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/dl_MatrixPrepare.h"
!
! --------------------------------------------------------------------------------------------------
!
! DYNA_VIBRA
!
! TYPE_CALCUL = 'HARM' + BASE_CALCUL = 'PHYS'
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ibid, nbold, isto1
    real(kind=8) :: r8bid
    complex(kind=8) :: c16bid
    character(len=8) :: k8bid
    character(len=8) :: resuco, result, resu1
    character(len=19) :: cn2mbr, vediri, veneum, vevoch, vassec
    character(len=19) :: lischa
    integer :: nbsym, i, n1
    integer :: lfreq, nbfreq
    integer :: nb_equa, nb_matr, ifm, niv
    integer :: ifreq, ieq, inom, ier, ierc
    integer :: lsecmb, jvezer, nbmodi, nbmody, nbbas, j
    integer :: icoef, icode, nbmode, jrefe
    integer :: linst, iret, ladpa, dec
    integer :: ldgec, lvgec, lagec, jordr, jfreq
    integer :: jdepl, jvite, jacce
    integer :: nbord, sstruct, nbsst
    integer :: freqpr, last_prperc, perc, nbpheq
    aster_logical :: newcal, calgen
    aster_logical :: l_damp, l_damp_modal, l_impe
    real(kind=8) :: depi, freq, omega, omeg2, fmin, fmax
    real(kind=8) :: rval, coef_vale(6), tps1(4), rtab(2)
    real(kind=8) :: fcal_min, fcal_max, epsi
    complex(kind=8) :: cval, czero
    character(len=1) :: typres, coef_type(4)
    character(len=4) :: typcal, nomsym(4)
    character(len=8) :: nomo, matass, modgen
    character(len=24) :: carele, mate
    character(len=14) :: numddl, nddlphys
    character(len=16) :: typcon, nomcmd, tysd, champs
    character(len=19) :: lifreq, masse, raide, amor, dynam, impe, chamno
    character(len=19) :: solveu, maprec, secmbr, soluti, vezero, crgc
    character(len=19) :: print_type
    character(len=24) :: matr_list(4), basemo, nume24, typco
    character(len=24) :: exreco, exresu
    integer :: nbexre, tmod(1)
    integer, pointer :: ordr(:) => null()
    character(len=24), pointer :: refa(:) => null()
    character(len=24), pointer :: nlmasse(:) => null()
    complex(kind=8), pointer :: secmb(:) => null()
    complex(kind=8), pointer :: solut(:) => null()
    complex(kind=8), pointer :: nlvale(:) => null()
    integer, pointer :: nequ(:) => null()
    real(kind=8), pointer :: mass_dia(:) => null()
    real(kind=8), pointer :: rigi_dia(:) => null()
    real(kind=8), pointer :: puls(:)     => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    call titre()
    call infmaj()
    call infniv(ifm,niv)
!
! - Initializations
!
    depi   = r8depi()
    epsi   = r8prem()
    typres = 'C'
    czero  = dcmplx(0.d0,0.d0)
!
! - Names of datastructures
!
    maprec = '&&COMDLH.MAPREC'
    soluti = '&&COMDLH.SOLUTI'
    vezero = '&&COMDLH.VEZERO'
    lischa = '&&COMDLH.LISCHA'
    vediri = '&&VEDIRI'
    veneum = '&&VENEUM'
    vevoch = '&&VEVOCH'
    vassec = '&&VASSEC'
    crgc   = '&&COMDLH_GCPC'
!
! --- NOM UTILISATEUR DU CONCEPT RESULTAT CREE PAR LA COMMANDE
!
    call getres(result, typcon, nomcmd)
!
! --- ON VERIFIE SI LE CONCEPT EST REENTRANT
!
    newcal = .true.
    call gcucon(result, typcon, iret)
    if (iret .gt. 0) then
        call getvid(' ', 'RESULTAT', scal=resuco, nbret=ibid)
        if (ibid .eq. 0) then
            call utmess('F', 'DYNALINE1_31')
        else
            call gettco(resuco, tysd)
            if (tysd .eq. typcon) then
                newcal = .false.
                if (result .ne. resuco) then
                    call utmess('F', 'DYNALINE1_28')
                endif
            else
                call utmess('F', 'DYNALINE1_29')
            endif
        endif
    endif
!
! --- CALGEN : FLAG POUR LES CALCULS SUR BASE GENERALISEE
    calgen=.false.
    if (typcon(1:9) .eq. 'HARM_GENE') then
        calgen=.true.
        typcal='HARM'
        isto1=0
!       --- CAS DE REPRISE DE CALCUL
        if (.not.newcal) then
            resu1 = result
            result='&&COMDLH'
        endif
    endif
!
! --- LISTE DES FREQUENCES POUR LE CALCUL
!
    call getvid(' ', 'LIST_FREQ', scal=lifreq, nbret=n1)
    if (n1 .gt. 0) then
        call jeveuo(lifreq//'.VALE', 'L', lfreq)
        call jelira(lifreq//'.VALE', 'LONMAX', nbfreq)
    else
        call getvr8(' ', 'FREQ', nbval=0, nbret=nbfreq)
        nbfreq = - nbfreq
        call wkvect('&&COMDLH.LISTE.FREQ', 'V V R', nbfreq, lfreq)
        call getvr8(' ', 'FREQ', nbval=nbfreq, vect=zr(lfreq))
    endif
!
! --- NOM DES CHAMPS CALCULES
!
    nomsym(:) = ' '
    call getvtx(' ', 'NOM_CHAM', nbval=3, nbret=nbsym)
    ASSERT(nbsym.le.3)
    if (typcon .eq. 'ACOU_HARMO') then
        nbsym = 1
        nomsym(1) = 'PRES'
    else
        call getvtx(' ', 'NOM_CHAM', nbval=3, vect=nomsym, nbret=nbsym)
        if (nbsym .eq. 0) then
            nbsym = 3
            nomsym(1) = 'DEPL'
            nomsym(2) = 'VITE'
            nomsym(3) = 'ACCE'
        endif
    endif
!
! --- RECUPERATION DES DESCRIPTEURS DES MATRICES ET DES MATRICES
!
    call dylema(raide       , masse    , amor  , impe,&
                l_damp_modal, l_damp   , l_impe   ,&
                nb_matr     , matr_list, coef_type, coef_vale,&
                dynam       , numddl   , nb_equa)
    ASSERT(nb_matr.le.4)
!
! --- LECTURE INFORMATIONS MECANIQUES
!
    call dydome(nomo, mate, carele)
!
! --- LECTURE DU CHARGEMENT
!
    call dylech(nomo, lischa, nbexre, exreco, exresu)
!
! --- CALCUL ET PRE-ASSEMBLAGE DU CHARGEMENT
!
    call dylach(nomo, mate, carele, lischa, numddl,&
                vediri, veneum, vevoch, vassec)
!
!============================================
! 3. ==> ALLOCATION DES RESULTATS
!============================================
!
    if (calgen) then
!     --- SI LE CALCUL EST SUR BASE GENERALISEE (NOUVEAU/REPRISE)
!       - RECUPERER LA BASE MODALE DE PROJECTION
        call jeveuo(masse(1:19)//'.REFA', 'L', vk24=nlmasse)
        basemo = nlmasse(1)
!
!       - ALLOUER LES VECTEURS DE TRAVAIL
        call wkvect('&&COMDLH.DEPGEC', 'G V C', nb_equa, ldgec)
        call wkvect('&&COMDLH.VITGEC', 'G V C', nb_equa, lvgec)
        call wkvect('&&COMDLH.ACCGEC', 'G V C', nb_equa, lagec)
!       - ALLOUER LES VECTEURS DE STOCKAGE DES RESULTATS
!       - ON RECHERCHE LES CHAMPS A REMPLIR POUR LE CAS HARMONIQUE
        if (nbsym .eq. 0) then
            nbsym = 3
            nomsym(1) = 'DEPL'
            nomsym(2) = 'VITE'
            nomsym(3) = 'ACCE'
        endif
!
        call mdallo(result, 'HARM', nbfreq, sauve='GLOB', base=basemo,&
                    mass=masse, rigi=raide, amor=amor, nbmodes=nb_equa, jordr=jordr,&
                    jdisc=jfreq, jdepl=jdepl, jvite=jvite, jacce=jacce, nbsym=nbsym,&
                    nomsym=nomsym)
!
!
    else if (newcal) then
!     --- SI NOUVEAU CALCUL SUR BASE PHYSIQUE
        call utcrre(result, nbfreq)
        nbold=0
!
    else
!     --- SI REPRISE DE CALCUL SUR BASE PHYSIQUE
!       - AGRANDIR LA SD_RESULTAT DE NBOLD A NBOLD+NBFREQ
        call rsorac(result, 'LONUTI', 0, r8bid, k8bid,&
                    c16bid, r8bid, 'ABSOLU', tmod, 1,&
                    ibid)
        nbold=tmod(1)
        call rsagsd(result, nbfreq+nbold)
    endif
!
    if (.not.calgen) then
!       --- SAUVEGARDE DE LA COLLECTION .REFD POUR LES CALCULS SUR BASE PHYS
        call refdaj('F', result, nbfreq, numddl, 'DYNAMIQUE',&
                    [raide, masse, amor], iret)
    endif
!
!
!
!============================================
! 4. ==> CALCUL DES TERMES DEPENDANT DE LA FREQUENCE ET RESOLUTION
!         DU SYSTEME FREQUENCE PAR FREQUENCE
!============================================
!
! --- CREATION DU VECTEUR SECOND-MEMBRE
!
    cn2mbr = '&&COMDLH.SECOND.MBR'
    call wkvect(cn2mbr, 'V V C', nb_equa, lsecmb)
!
! --- CREATION SD TEMPORAIRES
!
    secmbr = '&&COMDLH.SECMBR'
    call vtcrem(secmbr, dynam, 'V', typres)
    call copisd('CHAMP_GD', 'V', secmbr, vezero)
    call jeveuo(secmbr(1:19)//'.VALE', 'E', vc=secmb)
    call jeveuo(vezero(1:19)//'.VALE', 'E', jvezer)
    call vecinc(nb_equa, czero, zc(jvezer))
!
! --- INFORMATIONS SOLVEUR
    solveu = '&&COMDLH.SOLVEUR'
    call cresol(solveu)

!
! --- EXTRA INFORMATION FOR REDUCED MODAL CALCULATIONS

    if (calgen) then
        call gettco(basemo,typco)
        sstruct = 0
        if (typco(1:9) .eq. 'MODE_MECA') then
            call dismoi('NUME_DDL', basemo, 'RESU_DYNA', repk=nddlphys)
            call dismoi('NB_EQUA', nddlphys, 'NUME_DDL', repi=nbpheq)
        else if (typco(1:9).eq.'MODE_GENE') then
            call dismoi('REF_RIGI_PREM', basemo, 'RESU_DYNA', repk=matass)
            call dismoi('NOM_NUME_DDL', matass, 'MATR_ASSE', repk=nddlphys)
            call jeveuo(nddlphys(1:14)//'.NUME.NEQU', 'L', vi=nequ)
            nbpheq = nequ(1)
        else
            sstruct = 1
        endif

        nbmode = nb_equa
        nume24 = numddl
        AS_ALLOCATE(vr=mass_dia, size=nbmode)
        AS_ALLOCATE(vr=rigi_dia, size=nbmode)
        AS_ALLOCATE(vr=puls, size=nbmode)
        call extdia(masse, nume24, sstruct, mass_dia)
        call extdia(raide, nume24, sstruct, rigi_dia)

        if (sstruct.eq.1) then
            call jeveuo(numddl(1:14)//'.NUME.REFN', 'L', jrefe)
            modgen = zk24(jrefe)(1:8)
            call jelira(modgen//'      .MODG.SSNO', 'NOMMAX', nbsst)

            nbmodi = 0
            nbmody = 0
            do i = 1, nbsst
                call mgutdm(modgen, ' ', i, 'NOM_BASE_MODALE', ibid, basemo)
                call dismoi('NB_MODES_DYN', basemo, 'RESULTAT', repi=nbbas)
                do j = 1, nbbas
                    omeg2 = 0.d0
                    if (mass_dia(nbmodi+j).gt.epsi) then
                        omeg2 = abs(rigi_dia(nbmodi+j)/mass_dia(nbmodi+j))
                    end if
                    puls (nbmodi+j) = sqrt(omeg2)
                end do
                nbmody = nbmody + nbbas
                call dismoi('NB_MODES_TOT', basemo, 'RESULTAT', repi=nbbas)
                nbmodi = nbmodi + nbbas
            end do
        else
            do i = 1, nbmode
                omeg2 = 0.d0
                if (mass_dia(i).gt.epsi) then
                    omeg2 = abs(rigi_dia(i)/mass_dia(i))
                end if
                puls (i) = sqrt(omeg2)
            enddo
        end if

        fmin =  1.d25
        fmax = -1.d25
        do i = 1, nbmode
            freq = puls(i)/depi
            if (freq.lt.fmin) fmin = freq
            if (freq.gt.fmax) fmax = freq
        enddo

        AS_DEALLOCATE(vr=mass_dia)
        AS_DEALLOCATE(vr=rigi_dia)
        AS_DEALLOCATE(vr=puls)
    else
        call dismoi('NOM_MODELE', raide, 'MATR_ASSE', repk=nomo)
    end if

    fcal_min =  1.d25
    fcal_max = -1.d25
    do i = 1, nbfreq
        freq = zr(lfreq-1+i)
        if (freq.lt.fcal_min) fcal_min = freq
        if (freq.gt.fcal_max) fcal_max = freq
    enddo
!
! --- IMPRESSIONS RECAPITULATIVES POUR L'UTILISATEUR
    print_type             = 'PHYSique'
    if (calgen) print_type = 'GENEralisee'
    call utmess('I', 'DYNAMIQUE_55', nk=3, valk=['D Y N A _ V I B R A',&
                                                 'HARMonique         ',&
                                                 print_type])

    if (calgen) then
!       1 - Calculation type : standard, substructuring
        if (sstruct.eq.0) then
            call utmess('I', 'DYNAMIQUE_56', nk=1, valk=[basemo],&
                                             ni=1, vali=[nbpheq])
        else
            call utmess('I', 'DYNAMIQUE_57', nk=2, valk=[basemo, numddl])
        end if
!       2 - Minimum and max frequencies
        call utmess('I', 'DYNAMIQUE_59', ni=1, vali=[nbmode],&
                                         nr=2, valr=[fmin, fmax])
    else
        call utmess('I', 'DYNAMIQUE_82', sk=nomo, si=nb_equa)
    end if

!   3 - Dynamic matrices
    call utmess('I', 'DYNAMIQUE_60')
    call utmess('I', 'DYNAMIQUE_61', nk=2, valk=[masse, raide])
    if (l_damp) then
        call utmess('I', 'DYNAMIQUE_62', sk=amor)
    else if (l_damp_modal) then
        call utmess('I', 'DYNAMIQUE_63')
    else
        call utmess('I', 'DYNAMIQUE_64')
    end if
    if (l_impe) then
        call utmess('I', 'DYNAMIQUE_87', sk=impe)
    endif

!   4 - Calculation and saving parameters
    champs = ' '
    do i = 1, nbsym
        dec = 5*(i-1)
        champs(dec+i:dec+i+3) = nomsym(i)(1:4)
    end do
    call utmess('I', 'DYNAMIQUE_88', nr=2, valr= [fcal_min, fcal_max],&
                                     si=nbfreq, sk=champs)

!
!====
! 4.2 ==> BOUCLE SUR LES FREQUENCES ---
!====
    call uttcpu('CPU.COMDLH', 'INIT', ' ')

!   NIVEAU D'IMPRESSION DE L'AVANCEMENT DE CALCUL
    freqpr = 5
    if (niv.eq.2) freqpr = 1
    last_prperc = 999

    do ifreq = 1, nbfreq
        call uttcpu('CPU.COMDLH', 'DEBUT', ' ')
!
! ----- CALCUL DES COEFF. POUR LES MATRICES
!
        freq = zr(lfreq-1+ifreq)
        omega = depi*freq
        coef_vale(2) = - omega2(freq)
        icoef = 2
        if ((l_damp) .or. (l_damp_modal)) then
            coef_vale(3) = 0.d0
            coef_vale(4) = omega
            icoef = 4
        endif
        if (l_impe) then
            coef_vale(icoef+1) = 0.d0
            coef_vale(icoef+2) = coef_vale(2) * depi * freq
        endif
!
! ----- CALCUL DU SECOND MEMBRE
!
        call dy2mbr(numddl, nb_equa, lischa, freq, vediri,&
                    veneum, vevoch, vassec, lsecmb)
!
! ----- APPLICATION EVENTUELLE EXCIT_RESU
!
        if (nbexre .ne. 0) then
            call dyexre(numddl, freq, nbexre, exreco, exresu,&
                        lsecmb)
        endif
!
! ----- CALCUL DE LA MATRICE DYNAMIQUE
!
        call mtcmbl(nb_matr, coef_type, coef_vale, matr_list, dynam,&
                    ' ', ' ', 'ELIM=')
        call jeveuo(dynam(1:19)//'.REFA', 'E', vk24=refa)
        refa(7) = solveu
        refa(8) = ' '
!
! ----- FACTORISATION DE LA MATRICE DYNAMIQUE
!
        call preres(solveu, 'V', icode, maprec, dynam,&
                    ibid, -9999)
        if ((icode.eq.1) .or. (icode.eq.2)) then
            call utmess('I', 'DYNAMIQUE_14', sr=freq)
        endif
!
! ----- RESOLUTION DU SYSTEME, CELUI DU CHARGEMENT STANDARD
!
        call zcopy(nb_equa, zc(lsecmb), 1, secmb, 1)
        call resoud(dynam, maprec, solveu, vezero, 0,&
                    secmbr, soluti, 'V', [0.d0], [c16bid],&
                    crgc, .true._1, 0, iret)
        call jeveuo(soluti(1:19)//'.VALE', 'L', vc=solut)
        call zcopy(nb_equa, solut, 1, zc(lsecmb), 1)
        call jedetr(soluti)
!
! ----- IMPRESSION DE L'ETAT D'AVANCEMENT DU CALCUL FREQUENTIEL
!
        perc = int(100.d0*(real(ifreq)/real(nbfreq)))
        if ((perc.ne.last_prperc).or.(ifreq.eq.1) )then
            if ((mod(perc,freqpr).eq.0).or.(ifreq.eq.1)) then
                call utmess('I', 'DYNAMIQUE_95', ni=2, vali=[perc, ifreq],&
                                                 sr=freq)
                last_prperc = perc
            end if
        end if

!
! ----------------------------------------------------------------
! --- ARCHIVAGE DES RESULTATS SUR BASE PHYSIQUE OU GENERALISEE ---
! ----------------------------------------------------------------
!

        if (.not.calgen) then
!       --- SI CALCUL SUR BASE PHYSIQUE
!         - CREER UN CHAM_NO DANS LA SD_RESULTAT
            do inom = 1, nbsym
!         --- BOUCLE SUR LES CHAMPS A STOCKER (DEPL,VITE,ACCE)
                call rsexch(' ', result, nomsym(inom), ifreq+nbold, chamno,&
                            ier)
!
!           --- RECHERCHE SI IL EST "POSSIBLE" D'ECRIRE LE CHAMP DANS
!             - RESULTAT
                if (ier .eq. 0) then
!           --- LE CHAMPS EXISTE DEJA ALORS IL Y A UN PBLM, MESSAGE
!             - D'ALARME
                    call utmess('A', 'ALGORITH2_64', sk=chamno)
!
                else if (ier .eq. 100) then
!           --- LE CHAMPS N'EXISTE PAS ET IL EST POSSIBLE DE LE CREER
                    call vtcrem(chamno, masse, 'G', typres)
!             --- CREATION D'UN CHAM_NO S'APPUYANT SUR LA NUMEROTATION
!               - DE LA MATRICE ASSEMBLEE DE MASSE
!
                else
                    ASSERT(ASTER_FALSE)
                endif
!
!           --- RECOPIE DANS L'OBJET RESULTAT
                call jeveuo(chamno//'.VALE', 'E', vc=nlvale)
                if ((nomsym(inom) .eq. 'DEPL' ) .or. ( nomsym(inom) .eq. 'PRES' )) then
                    do ieq = 0, nb_equa-1
                        nlvale(ieq+1) = zc(lsecmb+ieq)
                    end do
                else if (nomsym(inom) .eq. 'VITE') then
                    cval = dcmplx(0.d0,depi*freq)
                    do ieq = 0, nb_equa-1
                        nlvale(ieq+1) = cval * zc(lsecmb+ieq)
                    end do
                else if (nomsym(inom) .eq. 'ACCE') then
                    rval = coef_vale(2)
                    do ieq = 0, nb_equa-1
                        nlvale(ieq+1) = rval * zc(lsecmb+ieq)
                    end do
                endif
                call rsnoch(result, nomsym(inom), ifreq+nbold)
                call jelibe(chamno//'.VALE')
            end do
!         --- FIN DE LA BOUCLE 130 SUR LES CHAMPS A STOCKER
!
!         --- RECOPIE DE LA FREQUENCE DE STOCKAGE
            call rsadpa(result, 'E', 1, 'FREQ', ifreq+nbold,&
                        0, sjv=linst, styp=k8bid)
            zr(linst) = freq
!
        else
!       --- SI CALCUL SUR BASE GENERALISEE
!         - REMPLISSAGE DES VECTEURS DE TRAVAIL: DEPGEC,VITGEC,ACCGEC
            do inom = 1, nbsym
                if (nomsym(inom) .eq. 'DEPL') then
                    do ieq = 0, nb_equa-1
                        zc(ldgec+ieq) = zc(lsecmb+ieq)
                    end do
                else if (nomsym(inom) .eq. 'VITE') then
                    cval = dcmplx(0.d0,depi*freq)
                    do ieq = 0, nb_equa-1
                        zc(lvgec+ieq) = cval * zc(lsecmb+ieq)
                    end do
                else if (nomsym(inom) .eq. 'ACCE') then
                    rval = coef_vale(2)
                    do ieq = 0, nb_equa-1
                        zc(lagec+ieq) = rval * zc(lsecmb+ieq)
                    end do
                endif
!
            end do
            call mdarch('HARM', isto1, ifreq-1, freq, nb_equa,&
                        zi(jordr), zr(jfreq), nbsym=nbsym, nomsym=nomsym, depgec=zc(ldgec),&
                        vitgec=zc(lvgec), accgec=zc(lagec), depstc=zc(jdepl), vitstc=zc(jvite),&
                        accstc=zc(jacce))
            isto1=isto1+1
        endif
!
!
! ----- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
!
        if (etausr() .eq. 1) then
            call sigusr()
        endif
!
! ----- MESURE CPU
!
        call uttcpu('CPU.COMDLH', 'FIN', ' ')
        call uttcpr('CPU.COMDLH', 4, tps1)
        if (tps1(4) .gt. .90d0*tps1(1) .and. i .ne. nbfreq) then
            rtab(1) = tps1(4)
            rtab(2) = tps1(1)
            call utmess('Z', 'DYNAMIQUE_13', si=ifreq, nr=2, valr=rtab,&
                        num_except=28)
        endif
    end do

!
!     --- DETRUIRE LES OBJETS TEMPORAIRES A LA FIN DU CALCUL GENE
    if (calgen) then
        call jedetr('&&COMDLH.DEPGEC')
        call jedetr('&&COMDLH.VITGEC')
        call jedetr('&&COMDLH.ACCGEC')
    endif
!
! --- STOCKAGE : MODELE,CARA_ELEM,CHAM_MATER, CALCUL PHYSIQUE
!
    if (.not.calgen) then
        call dismoi('NOM_MODELE', raide, 'MATR_ASSE', repk=nomo)
        call dismoi('CHAM_MATER', raide, 'MATR_ASSE', repk=mate, arret = 'C', ier = ierc)
        ! call dismoi('CHAM_MATER', raide, 'MATR_ASSE', repk=mate)
        call dismoi('CARA_ELEM', raide, 'MATR_ASSE', repk=carele)
        call jeveuo(result//'           .ORDR', 'L', vi=ordr)
        call jelira(result//'           .ORDR', 'LONUTI', nbord)
        do i = 1, nbord
            call rsadpa(result, 'E', 1, 'MODELE', ordr(i),&
                        0, sjv=ladpa, styp=k8bid)
            zk8(ladpa) = nomo
            if (ierc.ne.0) then
                call utmess('A', 'CHAMPS_21')
            else
                call rsadpa(result, 'E', 1, 'CHAMPMAT', ordr(i),&
                        0, sjv=ladpa, styp=k8bid)
                zk8(ladpa) = mate(1:8)
            endif

            call rsadpa(result, 'E', 1, 'CARAELEM', ordr(i),&
                        0, sjv=ladpa, styp=k8bid)
            zk8(ladpa) = carele(1:8)
        end do
    endif
!
! --- CAS DE REPRISE AVEC CALCUL SUR BASE GENERALISE
!
    if (calgen .and. (.not.newcal)) then
        call resu60(resu1, result)
    endif
!
    call jedema()
end subroutine
