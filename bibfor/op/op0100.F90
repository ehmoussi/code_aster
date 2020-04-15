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

subroutine op0100()
!      OPERATEUR :     CALC_G
!
!      BUT:CALCUL DU TAUX DE RESTITUTION D'ENERGIE PAR LA METHODE THETA
!          CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES
! ======================================================================
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/cakg2d.h"
#include "asterfort/cakg3d.h"
#include "asterfort/ccbcop.h"
#include "asterfort/cgcrio.h"
#include "asterfort/cgcrtb.h"
#include "asterfort/cglecc.h"
#include "asterfort/cgleco.h"
#include "asterfort/cglect.h"
#include "asterfort/cgtabl.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/gcncon.h"
#include "asterfort/gcou2d.h"
#include "asterfort/gcour2.h"
#include "asterfort/gcour3.h"
#include "asterfort/gettco.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/gver2d.h"
#include "asterfort/gveri3.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerecu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecagl.h"
#include "asterfort/mecalg.h"
#include "asterfort/medomg.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsmena.h"
#include "asterfort/rsrusd.h"
#include "asterfort/tbexve.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/xcourb.h"
    integer :: nbord, iord, i, ivec, iret, nbpara
    integer :: lnoff, jinst, ndeg, nbropt, iadrco, ipuls, iord0, icham
    integer :: iadfis, iadnoe
    integer :: ndimte, ndim, jopt, nb_objet, nb_cham_theta
    integer, parameter :: nxpara = 15
!
    real(kind=8) :: time, dir(3), rinf, rsup, puls
    character(len=6) :: nompro
    parameter  ( nompro = 'OP0100' )
    character(len=8) :: modele, resu, k8bid, calsig, resuc2
    character(len=8) :: nomfis, litypa(nxpara), symech, config
    character(len=8) :: table_g, noma, thetai, noeud, typfis, typfon, table_container
    character(len=16) :: option, typsd, linopa(nxpara)
    character(len=16) :: k16bid, typdis
    character(len=19) :: lischa, lisopt, vecord, grlt
    character(len=24) :: depla, mate, compor, chvite, chacce, mateco
    character(len=24) :: basfon, fonoeu, liss, taillr
    character(len=24) :: chfond, basloc, theta
    character(len=24) :: nomno, coorn
    character(len=24) :: trav1, trav2, trav3, stok4
    character(len=24) :: trav4, courb
    character(len=24) :: norfon
    character(len=16), pointer :: obje_name(:) => null()
    character(len=24), pointer :: obje_sdname(:) => null()
    character(len=24), pointer :: v_chtheta(:) => null()

    parameter  ( resuc2 = '&&MECALG' )
!
    aster_logical :: exitim, connex, milieu
    aster_logical :: incr, lmoda
    integer, pointer :: ordr(:) => null()
!
!     ==============
!     1. PREALABLES
!     ==============
!
    call jemarq()
    call infmaj()
!
    lischa = '&&'//nompro//'.CHARGES'
    courb = '&&'//nompro//'.COURB'
    trav1 = '&&'//nompro//'.TRAV1'
    trav2 = '&&'//nompro//'.TRAV2'
    trav3 = '&&'//nompro//'.TRAV3'
    trav4 = '&&'//nompro//'.TRAV4'
    stok4 = '&&'//nompro//'.STOK4'
!
!     ========================================
!     2. LECTURE ET VERIFICATION DES OPERANDES
!     ========================================
!
!     CREATION DES OBJETS :
!     - RESU, MODELE, NDIM
!     - OPTION
!     - TYPFIS, NOMFIS
!     - FONOEU, CHFOND, BASFON, TAILLR
!     - CONFIG
!     - LNOFF
!     - LISS, NDEG
!     - TYPDIS
    call cglect(resu, modele, ndim, option,&
                typfis, nomfis, fonoeu, chfond, basfon,&
                taillr, config, lnoff, liss, ndeg, typdis)
!
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=noma)
    nomno = noma//'.NOMNOE'
    coorn = noma//'.COORDO    .VALE'
    call jeveuo(coorn, 'L', iadrco)
!     RECUPERATION DES COORDONNEES POINTS FOND DE FISSURE ET ABSC CURV
    if (typfis.ne.'THETA') then
        call jeveuo(chfond, 'L', iadfis)
    else
        iadfis=0
    endif
!     RECUPERATION DU NOM DES NOEUDS DU FOND DE FISSURE
    if (typfis .eq. 'FONDFISS') then
        call jeveuo(fonoeu, 'L', iadnoe)
    endif
!
!     RECUPERATION DU CONCEPT DE SORTIE : table_container
    call getres(table_container, k16bid, k16bid)
    call gcncon("_", table_g)
    call gcncon("_", thetai)
    call gcncon("_", theta)
!
!     CREATION DU VECTEUR DES NUME_ORDRE
    vecord = '&&OP0100.VECTORDR'
    call cgcrio(resu, vecord)
    call jeveuo(vecord, 'L', ivec)
    call jelira(vecord, 'LONMAX', nbord)
!
!     MODE_MECA OU PAS
    lmoda = .false.
    call gettco(resu, typsd)
    if (typsd .eq. 'MODE_MECA') then
        if (option .eq. 'CALC_K_G') then
            lmoda = .true.
        else
            call utmess('F', 'RUPTURE0_27')
        endif
    endif
!
!     PREMIER NUME_ORDRE
    iord0 = zi(ivec)
!
!     RECUPERATION MODELE, MATE ET LISCHA
    call medomg(resu, iord0, modele, mate, mateco, lischa)
!
!     RECUPERATION DE LA CARTE DE COMPORTEMENT UTILISEE DANS LE CALCUL
!     -> COMPOR, INCR
    call cgleco(resu, modele, mate, iord0, compor(1:19),&
                incr)
!
!     ATTENTION, INCR EST MAL GERE : VOIR MECAGL !!
!
!     LECTURE ET VERIFICATION RELATIVE AU MOT-CLE CALCUL_CONTRAINTE
    call cglecc(typfis, resu, vecord, calsig)
!
!      ---------------- DEBUT DU GROS PAQUET A EPURER ---------------
!
!     ON RECHERCHE LA PRESENCE DE SYMETRIE
    symech='NON'
    if (typfis .eq. 'FONDFISS') then
        call dismoi('SYME', nomfis, 'FOND_FISS', repk=symech)
    endif
!
!     CALCUL DU CHAMP THETA (2D)
    if (ndim .eq. 2) then
!
!
        call gver2d(1, noeud,rinf, rsup)
        call gcou2d('G', theta, noma, nomno, noeud,zr(iadrco),&
                         rinf, rsup,  dir)
    endif
!
!     DETERMINATION AUTOMATIQUE DE THETA (CAS 3D)
    if (ndim .eq. 3 .and. typfis .eq. 'FISSURE') then
!
        call dismoi('TYPE_FOND', nomfis, 'FISS_XFEM', repk=typfon)
!
        if (typfon .eq. 'FERME') then
            connex = .true.
        else
            connex = .false.
        endif
!
        if (liss .eq. 'LEGENDRE' .or. liss .eq. 'MIXTE') then
            if (connex) call utmess('F', 'RUPTURE0_90')
        endif
!
        grlt = nomfis//'.GRLTNO'
!
        call gveri3(chfond, taillr, config, lnoff,&
                    liss, ndeg, trav1, trav2, trav3, typdis)
        call gcour3(thetai, noma, coorn, lnoff, trav1,&
                    trav2, trav3, chfond, connex, grlt,&
                    liss, basfon, ndeg, milieu,&
                    ndimte, typdis, nomfis)
!
    else if (ndim.eq. 3 .and.typfis.eq.'FONDFISS') then
!
!       A FAIRE : DISMOI POUR RECUP CONNEX ET METTRE DANS CGLECT
        call dismoi('TYPE_FOND', nomfis, 'FOND_FISS', repk=typfon)
        if (typfon .eq. 'FERME') then
            connex = .true.
        else
            connex = .false.
        endif
!
        if (liss .eq. 'LEGENDRE' .or. liss .eq. 'MIXTE') then
            if (connex) then
                call utmess('F', 'RUPTURE0_90')
            endif
        endif
!
        call gveri3(chfond, taillr, config, lnoff, liss,&
                    ndeg, trav1, trav2, trav3, option)
        call gcour2(thetai, noma, nomno, coorn,&
                    lnoff, trav1, trav2, trav3, fonoeu, chfond, basfon,&
                    nomfis, connex, stok4, liss,&
                    ndeg, milieu, ndimte, norfon)
!
    endif
!
!     MENAGE
    if (ndim .eq. 3) then
        call jeexin(trav1, iret)
        if (iret .ne. 0) call jedetr(trav1)
        call jeexin(trav2, iret)
        if (iret .ne. 0) call jedetr(trav2)
        call jeexin(trav3, iret)
        if (iret .ne. 0) call jedetr(trav3)
        call jeexin(stok4, iret)
        if (iret .ne. 0) call jedetr(stok4)
    endif
!
!      ---------------- FIN DU GROS PAQUET A EPURER -----------------
!
!     =======================
!     3. CALCUL DE L'OPTION
!     =======================
!
!     CREATION DE LA table_g
!
    call cgcrtb(table_g, option, ndim, typfis, nxpara,&
                lmoda, nbpara, linopa, litypa)
!
!!    ARRET POUR CONTROLE DEVELOPPEMENT DANS CGCRTB
!    ASSERT(.false.)
!
!
    if (ndim.eq. 3 .and.option.eq.'CALC_K_G') then
!
!       -------------------------------
!       3.3. ==> CALCUL DE KG (3D LOC)
!       -------------------------------
!
        basloc=nomfis//'.BASLOC'
        call xcourb(basloc, noma, modele, courb)
!
        do i = 1, nbord
            iord = zi(ivec-1+i)
            call medomg(resu, iord, modele, mate, mateco, lischa)
            call rsexch('F', resu, 'DEPL', iord, depla,&
                        iret)
!
            if (lmoda) then
                call rsadpa(resu, 'L', 1, 'OMEGA2', iord,&
                            0, sjv=ipuls, styp=k8bid)
                puls = zr(ipuls)
                puls = sqrt(puls)
                time = 0.d0
            else
                call rsadpa(resu, 'L', 1, 'INST', iord,&
                            0, sjv=jinst, styp=k8bid)
                time = zr(jinst)
                exitim = .true.
            endif
!
!
            call cakg3d(option, table_g, modele, depla, thetai,&
                        mate, mateco, compor, lischa, symech, chfond,&
                        lnoff, basloc, courb, iord, ndeg,&
                        liss, ndimte,&
                        exitim, time, nbpara, linopa, nomfis,&
                        lmoda, puls, milieu,&
                        connex, iadfis, iadnoe, typdis)
!
        end do
!
!     -------------------------------
!     3.5. ==> CALCUL DE G, K_G (2D)
!     -------------------------------
!
    else
!
        if (incr) then
            lisopt = '&&OP0100.LISOPT'
            nbropt = 2
!
            call wkvect(lisopt, 'V V K16', nbropt, jopt)
            zk16(jopt) = 'VARI_ELNO'
            zk16(jopt+1) = 'EPSP_ELNO'
!
            call ccbcop(resu, resuc2, vecord, nbord, lisopt,&
                        nbropt)
        endif
!
        do i = 1, nbord
            call jemarq()
            call jerecu('V')
            iord = zi(ivec-1+i)
            call medomg(resu, iord, modele, mate, mateco, lischa)
!
            call rsexch('F', resu, 'DEPL', iord, depla,&
                        iret)
            call rsexch(' ', resu, 'VITE', iord, chvite,&
                        iret)
            if (iret .ne. 0) then
                chvite = ' '
            else
                call rsexch(' ', resu, 'ACCE', iord, chacce,&
                            iret)
            endif
!
            if (lmoda) then
                call rsadpa(resu, 'L', 1, 'OMEGA2', iord,&
                            0, sjv=ipuls, styp=k8bid)
                puls = zr(ipuls)
                puls = sqrt(puls)
                time = 0.d0
            else
                call rsadpa(resu, 'L', 1, 'INST', iord,&
                            0, sjv=jinst, styp=k8bid)
                time = zr(jinst)
                exitim = .true.
            endif
!
            if (option(1:6).eq.'CALC_G'.and. ndim.eq. 2) then
!
                call mecalg(option, table_g, modele, depla, theta,&
                            mate, mateco, lischa, symech, compor, incr,&
                            time, iord, nbpara, linopa, chvite,&
                            chacce, calsig, iadfis, iadnoe)
!
            else if (option(1:6).eq.'CALC_G'.and. ndim .eq.3) then
!
                call mecagl(option, table_g, modele, depla, thetai,&
                            mate, mateco, compor, lischa, symech, chfond,&
                            lnoff, iord, ndeg, liss,&
                            milieu, ndimte, exitim,&
                            time, nbpara, linopa, chvite, chacce,&
                            calsig, fonoeu, incr, iadfis, &
                            norfon, connex)
!
            else if (option(1:6).eq.'CALC_K'.and. ndim .eq. 2) then
!
                call cakg2d(option, table_g, modele, depla, theta,&
                            mate, mateco, lischa, symech, nomfis, noeud,&
                            time, iord, nbpara, linopa,&
                            lmoda, puls, compor)
!
            else
                ASSERT(.false.)
            endif
!
            call jedema()
        end do
!
        if (incr) then
            call jeexin(resuc2//'           .ORDR', iret)
            if (iret .ne. 0) then
                call jeveuo(resuc2//'           .ORDR', 'L', vi=ordr)
                call rsrusd(resuc2, ordr(1))
                call detrsd('RESULTAT', resuc2)
            endif
!
            call jedetr('&&MECALCG.VECTORDR')
            call jedetr('&&MECALG')
            call rsmena(resu)
        endif
!
    endif
!
! --- Create table_container to store (calc_g and cham_theta)
!
    if (ndim .eq. 2) then
        nb_cham_theta = 1
    else if (ndim .eq. 3) then
        nb_cham_theta = ndimte
    else
        ASSERT(ASTER_FALSE)
    end if
!
    AS_ALLOCATE(vk16=obje_name, size=nb_cham_theta+2)
    AS_ALLOCATE(vk24=obje_sdname, size=nb_cham_theta+2)
!
    obje_name(1)   = "TABLE_G"
    obje_sdname(1) = table_g
    nb_objet       = 1
!
    if (ndim .eq. 2) then
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "NB_CHAM_THETA"
        obje_sdname(nb_objet) = " "
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "CHAM_THETA"
        obje_sdname(nb_objet) = theta
    else if (ndim .eq. 3) then
        call jeveuo(thetai, 'L', vk24=v_chtheta)
        nb_objet              = nb_objet + 1
        obje_name(nb_objet)   = "NB_CHAM_THETA"
        obje_sdname(nb_objet) = " "
        do icham = 1, nb_cham_theta
            nb_objet              = nb_objet + 1
            obje_name(nb_objet)   = "CHAM_THETA"
            obje_sdname(nb_objet) = v_chtheta(icham)
        end do
    else
        ASSERT(ASTER_FALSE)
    end if
!
    call cgtabl(table_container, nb_objet, obje_name, obje_sdname, nb_cham_theta)
    AS_DEALLOCATE(vk16=obje_name)
    AS_DEALLOCATE(vk24=obje_sdname)
!
    call titre()
!
    call detrsd('CARTE', '&&NMDORC.COMPOR')
!
    call jedema()
!
end subroutine
