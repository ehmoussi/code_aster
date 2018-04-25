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

subroutine cppagn(main, maout, nbma, lima, izone, typ_dec)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeccta.h"
#include "asterfort/jeexin.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/juveca.h"
#include "asterfort/wkvect.h"
#include "asterfort/utmess.h"
#include "asterfort/cnmpmc.h"
#include "asterfort/jelira.h"
#include "asterfort/codent.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utlisi.h"
#include "asterfort/cpclma.h"
#include "asterfort/jenonu.h"
#include "asterfort/cpte04.h"
#include "asterfort/cpte10.h"
#include "asterfort/cphe08.h"
#include "asterfort/cphe08_2.h"
#include "asterfort/cphe20.h"
#include "asterfort/cphe20_2.h"
#include "asterfort/cphe27.h"
#include "asterfort/cptr03.h"
#include "asterfort/cptr06.h"
#include "asterfort/cpqu08.h"
#include "asterfort/cpqu04.h"
#include "asterfort/cppt6_1.h"
#include "asterfort/cppt6_2.h"
#include "asterfort/cppt15_1.h"
#include "asterfort/cppt15_2.h"
#include "asterfort/cppy5_1.h"
#include "asterfort/cppy5_2.h"
#include "asterfort/cppy13_1.h"
#include "asterfort/cppy13_2.h"
#include "asterfort/coppat.h"
!
!
    character(len=8), intent(in) :: main
    character(len=8), intent(in) :: maout
    integer, intent(in) :: nbma
    integer, intent(in) :: lima(nbma)
    integer, intent(in) :: izone
    integer, intent(in) :: typ_dec
!

! -------------------------------------------------------------------------------------------------
!        CREATION DES PATCHS ET MODIFICATION DU MAILLAGE
!                   POUR LE CONTACT METHODE LAC
! -------------------------------------------------------------------------------------------------
! IN        MAIN   K8  NOM DU MAILLAGE INITIAL
! IN/JXOUT  MAOUT  K8  NOM DU MAILLAGE TRANSFORME
! IN        NBMA    I  NOMBRE DE MAILLES A TRAITER
! IN        LIMA    I  NUMERO DES MAILLES A TRAITER
! IN        IZONE   I  NUMERO DE LA ZONE DE CONTACT
! IN        TYP_DEC I  TYPE DE DECOUPE POUR LES HEXA 1:PYRA 2:HEXA
! -------------------------------------------------------------------------------------------------
    integer :: inc, patch, nbnot, nbmat, info, nma, nbno, ind1, nbnwma, nbpain
    integer :: jdim, jrefe, macou, macsu, jcninv, jcivax, jcoor, jgmao
    integer :: jmacsu, jmacou, jlimane, jconloc, lgma, inc2, jcnmpa, jcnnpa
    integer :: ind, res(1), ntrou, jtpmao, jtypma, aux, numa, laux(1)
    integer :: jcnmai, jcnmao, incc, ntrou1, jgma, jrgma
    integer :: conlen, cnlclg, idtpma(6), nbnoma(6), odcnpa, odcmpa,lenconloc, lenlimane, lenpat
!
    character(len=24) :: nomnoi, nomnoe, limane, conloc
    character(len=24) :: nomnd, nomma, cninv, cnivax, rgma, gpptnn
    character(len=19) :: coordo
    character(len=16) :: knume,knuzo
    character(len=8) :: typmail,typmail_trait
    aster_logical :: false
! -------------------------------------------------------------------------------------------------
    call jemarq()
    false=.false.
    nbpain = 0

! --- DUPLICATION A L'IDENTIQUE DES GROUPES DE NOEUDS (PAS DE MISE A JOUR) ------------------------
    call cpclma(main, maout, 'GROUPENO', 'G')
! --- DIMENSION DU NOUVEAU MAILLAGE, DES CONNECTIVITE (AUXILAIRE ET NOUVELLE) ---------------------
    call jeveuo(main//'.DIME', 'L', info)
    nbno = zi(info-1+1)
    nma = zi(info-1+3)
    call jeveuo(main//'.TYPMAIL','L',jtypma)
    nbnot= nbno
    nbmat= nma
    conlen = 0
    cnlclg = 0
    lenconloc = 0
    lenpat    = 0
    lenlimane = nma-nbma*2
    cninv='&&CPPAGN.CNINV'
    call wkvect(cninv,'V V I', nbma, jcninv)
    call cnmpmc(main,nbma, lima,zi(jcninv))
    do inc= 1, nbma
        macou=lima(inc)
        macsu = zi(jcninv+inc-1)
        call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macsu-1)), typmail)
        select case (typmail)
! -------- CAS 2D
            case('TRIA3')
                !nombre de noeuds du maillage maout
                nbnot = nbnot + 1
                !nombre de mailles du maillage maout
                nbmat = nbmat + 2
                !nombre d'elements à ajouter a la connectivité du maillage maout
                conlen = conlen + 1*2 + 1*3
                !dimension de la connectivité locale de transfert
                lenconloc = lenconloc + 2*3 + 2*2
                !nombre de de la connectivité locale de transfert
                cnlclg = cnlclg + 4
                !dimension de la connectivité  ancienne nouvelle maille
                !(+ 1 pour le pacth sous jacent)
                lenlimane = lenlimane + 3 + 2
                !dimension du vecteur .patch
                lenpat = lenpat + 2
            case ('QUAD4')
                nbnot = nbnot + 4
                nbmat = nbmat + 5
                conlen = conlen + 2*2 + 3*4
                lenconloc = lenconloc + 3*2 + 4*4
                cnlclg = cnlclg + 7
                lenlimane = lenlimane + 4 + 4
                lenpat = lenpat + 3
            case ('TRIA6')
                nbnot = nbnot + 0
                nbmat = nbmat + 0
                conlen = conlen + 0
                lenconloc = lenconloc + 3 + 6
                cnlclg = cnlclg + 2
                lenlimane = lenlimane + 2 + 1
                lenpat = lenpat + 2
            case ('QUAD8')
                nbnot = nbnot + 0
                nbmat = nbmat + 0
                conlen = conlen + 0
                lenconloc = lenconloc + 3 + 8
                cnlclg = cnlclg + 2
                lenlimane = lenlimane + 2 + 1
                lenpat = lenpat + 2
! -------- CAS 3D
            case ('TETRA4')
                nbnot = nbnot + 1
                nbmat = nbmat + 4
                conlen = conlen + 2*3 + 2*4
                cnlclg = cnlclg + 6
                lenconloc = lenconloc + 3*3 + 4*3
                lenlimane = lenlimane + 3 + 4
                lenpat = lenpat + 2
            case ('PENTA6')
                if(zi(jtypma+macou-1).eq.7)then
                    nbnot = nbnot + 1
                    nbmat = nbmat + 5
                    conlen = conlen + 2*3 + 3*5 + 1*4 - 6
                    lenconloc = lenconloc + 3*3 + 3*5 + 1*4
                    cnlclg = cnlclg + 7
                    lenlimane = lenlimane + 3 + 4 +1
                    lenpat = lenpat + 2
                else
                    nbnot = nbnot + 1
                    nbmat = nbmat + 6
                    conlen = conlen + 4*3 + 2*5 + 2*4 - 6 -4
                    lenconloc = lenconloc + 4*3 + 2*5 + 2*4
                    cnlclg = cnlclg + 8
                    lenlimane = lenlimane + 8 +1
                    lenpat = lenpat + 2
                endif
            case ('PYRAM5')
                if(zi(jtypma+macou-1).eq.12)then
                    nbnot = nbnot + 1
                    nbmat = nbmat + 6
                    conlen = conlen + 4*3 + 4*4 - 4 - 5
                    lenconloc = lenconloc + 4*3 + 4*4
                    cnlclg = cnlclg + 8
                    lenlimane = lenlimane + 4 + 4 +1
                    lenpat = lenpat + 2
                else
                    nbnot = nbnot + 1
                    nbmat = nbmat + 5
                    conlen = conlen + 3*3 + 1*5 + 3*4 - 3 - 5
                    lenconloc = lenconloc + 3*3 + 1*5 + 3*4
                    cnlclg = cnlclg + 7
                    lenlimane = lenlimane + 7 +1
                    lenpat = lenpat + 2
                endif
            case ('TETRA10')
                nbnot = nbnot + 5
                nbmat = nbmat + 4
                conlen = conlen + 2*6 + 2*10
                cnlclg = cnlclg + 6
                lenconloc = lenconloc + 3*6 + 3*10
                lenlimane = lenlimane + 3 + 3 +1
                lenpat = lenpat + 2
            case ('HEXA8')
                if (typ_dec.eq.0) then
                    nbnot = nbnot + 8
                    nbmat = nbmat + 9
                    conlen = conlen + 4*4 + 5*8
                    lenconloc = lenconloc + 5*4 + 6*8
                    cnlclg = cnlclg + 11
                    lenlimane = lenlimane + 6 + 7
                    lenpat = lenpat + 5
                else
                    nbnot = nbnot + 1
                    nbmat = nbmat + 7
                    conlen = conlen + 4*3-4 + 5*5-8
                    lenconloc = lenconloc + 4*3 + 5*5
                    cnlclg = cnlclg + 9
                    lenlimane = lenlimane + 5 + 5
                    lenpat = lenpat + 2
                end if
            case ('HEXA20')
                if (typ_dec.eq.0) then
                    nbnot = nbnot + 28
                    nbmat = nbmat + 9
                    conlen = conlen + 4*8 + 5*20
                    lenconloc = lenconloc + 5*8 + 6*20
                    cnlclg = cnlclg + 11
                    lenlimane = lenlimane + 6 + 7
                    lenpat = lenpat + 5
                else
                    nbnot = nbnot + 9
                    nbmat = nbmat + 7
                    conlen = conlen + 4*6-8 + 5*13-20
                    lenconloc = lenconloc + 4*6 + 5*13
                    cnlclg = cnlclg + 9
                    lenlimane = lenlimane + 5 + 5
                    lenpat = lenpat + 2
                endif
            case ('HEXA27')
                nbnot = nbnot + 0
                nbmat = nbmat + 0
                conlen = conlen + 0
                lenconloc = lenconloc + 27 + 9
                cnlclg = cnlclg + 2
                lenlimane = lenlimane + 2 + 1
                lenpat = lenpat + 2
            case ('PENTA15')
                if(zi(jtypma+macou-1).eq.9)then
                    nbnot = nbnot + 7
                    nbmat = nbmat + 5
                    conlen = conlen + 2*6 + 3*13 + 1*10 - 15
                    lenconloc = lenconloc + 3*6 + 3*13 + 1*10
                    cnlclg = cnlclg + 7
                    lenlimane = lenlimane + 3 + 4 +1
                    lenpat = lenpat + 2
                else
                    nbnot = nbnot + 7
                    nbmat = nbmat + 6
                    conlen = conlen + 4*6 + 2*13 + 2*10 - 15 -8
                    lenconloc = lenconloc + 4*6 + 2*13 + 2*10
                    cnlclg = cnlclg + 8
                    lenlimane = lenlimane + 8 +1
                    lenpat = lenpat + 2
                endif
            case ('PYRAM13')
                if(zi(jtypma+macou-1).eq.14)then
                    nbnot = nbnot + 6
                    nbmat = nbmat + 6
                    conlen = conlen + 4*6 + 4*10 - 8 - 13
                    lenconloc = lenconloc + 4*6 + 4*10
                    cnlclg = cnlclg + 8
                    lenlimane = lenlimane + 4 + 4 +1
                    lenpat = lenpat + 2
                else
                    nbnot = nbnot + 6
                    nbmat = nbmat + 5
                    conlen = conlen + 3*6 + 1*13 + 3*10 - 6 - 13
                    lenconloc = lenconloc + 3*6 + 1*13 + 3*10
                    cnlclg = cnlclg + 7
                    lenlimane = lenlimane + 7 +1
                    lenpat = lenpat + 2
                endif
            case default
                call utmess('A', 'CREALAC_1')
                ASSERT(.false.)
        end select
    enddo
! --- CREATION OU RECUPERATION DE LA COLLECTION .PATCH --------------------------------------------
    if (izone .eq. 1) then
        call jecrec(maout//'.PATCH','G V I', 'NU', 'CONTIG', 'VARIABLE', nbma+1)
        call jeecra(maout//'.PATCH', 'LONT', ival=2+lenpat)
        call jecroc(jexnum(maout//'.PATCH',1))
        call jeecra(jexnum(maout//'.PATCH',1), 'LONMAX', ival=2)
        call jeecra(jexnum(maout//'.PATCH',1), 'LONUTI', ival=2)
        call jeveuo(jexnum(maout//'.PATCH',1), 'E', patch)
        zi(patch+1-1)=2
        zi(patch+2-1)=nbma
    else
        call coppat(main,maout,nbma,nbpain,lenpat)
    end if
! -------------------------------------------------------------------------------------------------
    call jedupo(main//'.DIME', 'G', maout//'.DIME', dupcol=false)
    call jeveuo(maout//'.DIME', 'E', jdim)
    zi(jdim-1 + 1) = nbnot
    zi(jdim-1 + 3) = nbmat
! --- CONNECTIVITE INVERSE NOEUD PATCH ------------------------------------------------------------
    call jedetr(maout//'.CONOPA')
    call wkvect(maout//'.CONOPA', 'G V I',nbnot, jcnnpa)
    if (izone .ne. 1) then
        call jeveuo(main//'.CONOPA', 'L', odcnpa)
        do inc=1,nbno
            zi(jcnnpa+inc-1) = zi(odcnpa+inc-1)
        end do
    end if
! --- REPERTOIRE DE NOM DES NOEUDS : COPIE DE LA PARTIE COMMUNE -----------------------------------
    nomnoi = main // '.NOMNOE'
    nomnoe = maout // '.NOMNOE'
    call jedetr(nomnoe)
    call jecreo(nomnoe, 'G N K8')
    call jeecra(nomnoe, 'NOMMAX', nbnot)
!
    do inc = 1, nbno
        call jenuno(jexnum(nomnoi, inc), nomnd)
        call jecroc(jexnom(nomnoe, nomnd))
    end do
! --- CHAM_GEOM : RECOPIE DE LA PARTIE COMMUNE ----------------------------------------------------
    coordo = maout // '.COORDO'
    call copisd('CHAMP_GD', 'G', main//'.COORDO', coordo)
    call jeveuo(coordo//'.REFE', 'E', jrefe)
    zk24(jrefe) = maout
    call juveca(coordo//'.VALE', nbnot*3)

! -------------------------------------------------------------------------------------------------
!      CREATION DES PATCHS, DES NOUEDS MILIEUX ET
!      DES NOUVELLES MAILLES SELON LE TYPE DE MAILLE INITIALE
! -------------------------------------------------------------------------------------------------
    ind = 1
    ind1 = 1
    limane='&&CPPAGN.LI_MANE'
    conloc='&&CPPAGN.CNLOC_MANE'
    call jecrec(conloc,'V V I', 'NU', 'CONTIG', 'VARIABLE',&
                cnlclg)
    call jeecra(conloc,'LONT', lenconloc)
! Initialisation connectivité maille maillage in maille maillage out
    call jecrec(limane,'V V I', 'NU', 'CONTIG', 'VARIABLE',&
                nma)
    call jeecra(limane,'LONT', lenlimane)
    do inc = 1, nma
        laux(1)=inc
        ntrou = 0
        ntrou1 = 0
        call utlisi('INTER', laux, 1, lima, nbma, res, 1, ntrou)
        call utlisi('INTER', laux, 1, zi(jcninv), nbma, res, 1, ntrou1)
        if (ntrou .eq. 1) then
            if (zi(jtypma+inc-1) .eq. 2) then
                do incc=1,nbma
                    if (lima(incc) .eq. inc) then
                        macsu=zi(jcninv+incc-1)
                        goto 30
                    else
                        macsu=0
                    end if
                end do
            end if
            30 continue
            select case (zi(jtypma+inc-1))
                case (2)
                    if (zi(jtypma+macsu-1).eq.7) then
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=3)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=3)
                    elseif (zi(jtypma+macsu-1).eq.12) then
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=4)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=4)
                    else
                        call utmess('A', 'CREALAC_1')
                        ASSERT(.false.)
                    endif
                case (4, 6, 16)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=2)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=2)
                case (7,9)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=4)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=4)
                case (12, 14)
                    if (typ_dec.eq.0 .and. &
                       (zi(jtypma+macsu-1).eq.25 .or.&
                        zi(jtypma+macsu-1).eq.26) ) then
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=6)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=6)
                    else
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=5)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=5)
                    end if
            end select
        elseif (ntrou1 .eq. 1) then
            select case (zi(jtypma+inc-1))
                case (7)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=2)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=2)
                case (12)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=4)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=4)
                case (9, 14 ,27)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=1)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=1)
                case (18,19)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=3)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=3)
                case (25, 26)
                    if (typ_dec.eq.0) then
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=7)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=7)
                    else
                        call jeecra(jexnum(limane, inc), 'LONMAX', ival=5)
                        call jeecra(jexnum(limane, inc), 'LONUTI', ival=5)
                    end if
                case (20, 21, 23, 24)
                    call jeecra(jexnum(limane, inc), 'LONMAX', ival=4)
                    call jeecra(jexnum(limane, inc), 'LONUTI', ival=4)
            end select
        elseif (ntrou1.eq.0 .and. ntrou .eq. 0) then
            call jeecra(jexnum(limane, inc), 'LONMAX', ival=1)
            call jeecra(jexnum(limane, inc), 'LONUTI', ival=1)
        end if

    end do
    call jeveuo(coordo//'.VALE', 'E', jcoor)
    do inc =1,nbma
        macou = lima(inc)
        call jeveuo(jexnum(main//'.CONNEX',lima(inc)), 'L', jmacou)
        macsu = zi(jcninv+inc-1)
        call jeveuo(jexnum(main//'.CONNEX',macsu), 'L', jmacsu)
        call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macsu-1)), typmail)
        select case (typmail)
! --- Cas 2D --------------------------------------------------------------------------------------
! --- CAS TRIA 3 ----------------------------------------------------------------------------------
            case ('TRIA3')
                call cptr03(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                            limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1)
! --- CAS QUAD4 -----------------------------------------------------------------------------------
            case ('QUAD4')
                call cpqu04(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                            limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1  )
! --- CAS TRIA 6 ---------------------------------------------------------------------------------
            case ('TRIA6')
                call cptr06(maout , inc+nbpain, jcnnpa, conloc,&
                            limane, jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1  )
! --- CAS QUAD 8 ---------------------------------------------------------------------------------
            case ('QUAD8')
                call cpqu08(maout , inc+nbpain, jcnnpa, conloc,&
                            limane, jmacou, jmacsu, macou ,&
                             macsu , ind   , ind1  )

! --- Cas 3D --------------------------------------------------------------------------------------
! --- CAS TETRA 4 ---------------------------------------------------------------------------------

            case ('TETRA4')
                call cpte04(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                            limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1)
! --- CAS TETRA 10 --------------------------------------------------------------------------------
            case ('TETRA10')
                call cpte10(main  , maout , inc+nbpain  , jcoor , jcnnpa, conloc,&
                            limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1  )

! --- CAS HEXA 8 ----------------------------------------------------------------------------------
            case ('HEXA8')
                if (typ_dec.eq.0) then
                    call cphe08(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                macsu , ind   , ind1)
                else
                    call cphe08_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                  limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                  macsu , ind   , ind1)
                end if

! --- CAS HEXA 20 ---------------------------------------------------------------------------------
           case ('HEXA20')
                if (typ_dec.eq.0) then
                    call cphe20(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                macsu , ind   , ind1  )
                else
                    call cphe20_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                end if

! --- CAS HEXA 27 ---------------------------------------------------------------------------------
           case ('HEXA27')
                call cphe27(maout , inc+nbpain, jcnnpa, conloc,&
                            limane, jmacou, jmacsu, macou ,&
                            macsu , ind   , ind1  )
! --- CAS PENTA 6 ---------------------------------------------------------------------------------
           case ('PENTA6')
                if (zi(jtypma+macou-1).eq.7) then
                    call cppt6_1(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                else
                    call cppt6_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                end if
! --- CAS PENTA 15 ---------------------------------------------------------------------------------
           case ('PENTA15')
                if (zi(jtypma+macou-1).eq.9) then
                    call cppt15_1(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                  limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                  macsu , ind   , ind1  )
                else
                    call cppt15_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                  limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                  macsu , ind   , ind1  )
                end if
! --- CAS PYRA 5 -----------------------------------------------------------------------
           case ('PYRAM5')
                if (zi(jtypma+macou-1).eq.12) then
                    call cppy5_1(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                else
                    call cppy5_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                end if
! --- CAS PYRA 13 -----------------------------------------------------------------------
           case ('PYRAM13')
                if (zi(jtypma+macou-1).eq.14) then
                    call cppy13_1(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                else
                    call cppy13_2(main  , maout , inc+nbpain   , jcoor , jcnnpa, conloc,&
                                 limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                                 macsu , ind   , ind1  )
                end if
            case default
                ASSERT(.false.)
        end select
    end do
! -------------------------------------------------------------------------------------------------
!      MISE A JOUR DES MAILLES ET DE LA CONNECTIVITE
! -------------------------------------------------------------------------------------------------
    call codent(izone, 'G', knuzo)
    call jedetr(maout//'.CONNEX')
    call jedetr(maout//'.NOMMAI')
    call jecrec(maout//'.CONNEX', 'G V I', 'NU', 'CONTIG', 'VARIABLE',&
                nbmat)
    call jedetr(maout//'.COMAPA')
    call wkvect(maout//'.COMAPA', 'G V I', nbmat, jcnmpa)
    if (izone .ne. 1) then
        call jeveuo(main//'.COMAPA', 'L', odcmpa)
    end if
    call juveca(maout//'.TYPMAIL', nbmat)
    call jeecra(maout//'.TYPMAIL', 'LONUTI', nbmat)
    call jeveuo(maout//'.TYPMAIL','E',jtpmao)
    call jecreo(maout//'.NOMMAI', 'G N K8')
    call jeecra(maout//'.NOMMAI', 'NOMMAX', nbmat)
!
    call jelira(main//'.CONNEX','LONT',aux)
    call jeecra(maout//'.CONNEX','LONT',aux+conlen)
    ind = 1
    ind1 = 1
    macou = 0
    do inc = 1, nma
        laux(1)=inc
        call utlisi('INTER', laux, 1, lima, nbma, res, 1, ntrou)
        call utlisi('INTER', laux, 1, zi(jcninv), nbma, res, 1, ntrou1)
        if (ntrou .eq. 1 .or. ntrou1 .eq. 1) then
            call jeveuo(jexnum(limane,inc),'E',jlimane)
    select case(ntrou)
       case(1)
           if (zi(jtypma+inc-1) .eq. 2 .or. zi(jtypma+inc-1) .eq. 12 .or. &
               zi(jtypma+inc-1) .eq. 14) then
               do incc=1,nbma
                   if (lima(incc) .eq. inc) then
                       macsu=zi(jcninv+incc-1)
                       goto 10
                   else
                       macsu=0
                   end if
               end do
           end if
           10 continue
           ASSERT(macsu .ne. 0)
           !  TYPMAIL = MAILLE  A TRAITER
           call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+inc-1)), typmail_trait)
           select case(typmail_trait)
               case('SEG2')
                   call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macsu-1)), typmail)
                   if ( typmail .eq. 'TRIA3') then
                       nbnwma = 2
                       nbnoma(1:nbnwma) = 2
                       idtpma(1:nbnwma) = 2
                   elseif (typmail .eq. 'QUAD4') then
                       nbnwma = 3
                       nbnoma(1:nbnwma) = 2
                       idtpma(1:nbnwma) = 2
                   end if
               case ('SEG3')
                   nbnwma = 1
                   nbnoma(1:nbnwma) = 3
                   idtpma(1:nbnwma) = 4
               case ('TRIA3')
                   nbnwma = 3
                   nbnoma(1:nbnwma) = 3
                   idtpma(1:nbnwma) = 7
               case ('TRIA6')
                   nbnwma = 3
                   nbnoma(1:nbnwma) = 6
                   idtpma(1:nbnwma) = 9
               case ('QUAD4')
                   if (typ_dec.eq.0 .and. zi(jtypma+macsu-1) .eq. 25 ) then
                       nbnwma = 5
                       nbnoma(1:nbnwma) = 4
                       idtpma(1:nbnwma) = 12
                   else
                       nbnwma = 4
                       nbnoma(1:nbnwma) = 3
                       idtpma(1:nbnwma) = 7
                   endif
               case ('QUAD8')
                   if (typ_dec.eq.0 .and. zi(jtypma+macsu-1) .eq. 26 ) then
                       nbnwma = 5
                       nbnoma(1:nbnwma) = 8
                       idtpma(1:nbnwma) = 14
                   else
                       nbnwma = 4
                       nbnoma(1:nbnwma) = 6
                       idtpma(1:nbnwma) = 9
                   end if
               case ('QUAD9')
                   nbnwma = 1
                   nbnoma(1:nbnwma) = 9
                   idtpma(1:nbnwma) = 16

               case default
                   ASSERT(.false.)
           end select
       case default
           if (zi(jtypma+inc-1) .eq. 20 .or. zi(jtypma+inc-1) .eq. 21 .or.&
               zi(jtypma+inc-1) .eq. 23 .or. zi(jtypma+inc-1) .eq. 24) then
               do incc=1,nbma
                   if (zi(jcninv+incc-1) .eq. inc) then
                       macou=lima(incc)
                       goto 20
                   else
                       macou=0
                   end if
               end do
               20 continue
           end if
           call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+inc-1)), typmail_trait)
           select case (typmail_trait)
               case ('TRIA3')
                   nbnwma = 2
                   nbnoma(1:nbnwma) = 3
                   idtpma(1:nbnwma) = 7
               case ('QUAD4')
                   nbnwma = 4
                   nbnoma(1:nbnwma) = 4
                   idtpma(1:nbnwma) = 12
               case ('TRIA6')
                   nbnwma = 1
                   nbnoma(1:nbnwma) = 6
                   idtpma(1:nbnwma) = 9
               case ('QUAD8')
                   nbnwma = 1
                   nbnoma(1:nbnwma) = 8
                   idtpma(1:nbnwma) = 14
               case ('TETRA4')
                   nbnwma = 3
                   nbnoma(1:nbnwma) = 4
                   idtpma(1:nbnwma) = 18
               case ('TETRA10')
                   nbnwma = 3
                   nbnoma(1:nbnwma) = 10
                   idtpma(1:nbnwma) = 19
               case ('HEXA8')
                   if (typ_dec.eq.0) then
                       nbnwma = 6
                       nbnoma(1:nbnwma) = 8
                       idtpma(1:nbnwma) = 25
                   else
                       nbnwma = 5
                       nbnoma(1:nbnwma) = 5
                       idtpma(1:nbnwma) = 23
                   end if
               case ('PENTA6')
                   if (zi(jtypma+macou-1).eq.7) then
                       nbnwma = 4
                       nbnoma(1:3) = 5
                       nbnoma(4) = 4
                       idtpma(1:3) = 23
                       idtpma(4) = 18
                   else
                       nbnwma = 4
                       nbnoma(1:2) = 5
                       nbnoma(3:4) = 4
                       idtpma(1:2) = 23
                       idtpma(3:4) = 18
                   end if
                case ('PYRAM5')
                   if (zi(jtypma+macou-1).eq.12) then
                       nbnwma = 4
                       nbnoma(1:4) = 4
                       idtpma(1:4) = 18
                   else
                       nbnwma = 4
                       nbnoma(1) = 5
                       nbnoma(2:4) = 4
                       idtpma(1) = 23
                       idtpma(2:4) = 18
                   end if
               case ('HEXA20')
                   if (typ_dec.eq.0) then
                       nbnwma = 6
                       nbnoma(1:nbnwma) = 20
                       idtpma(1:nbnwma) = 26
                   else
                       nbnwma = 5
                       nbnoma(1:nbnwma) = 13
                       idtpma(1:nbnwma) = 24
                   end if
               case ('HEXA27')
                   nbnwma = 1
                   nbnoma(1:nbnwma) = 27
                   idtpma(1:nbnwma) = 27
               case ('PENTA15')
                   if (zi(jtypma+macou-1).eq.9) then
                       nbnwma = 4
                       nbnoma(1:3) = 13
                       nbnoma(4) = 10
                       idtpma(1:3) = 24
                       idtpma(4) = 19
                   else
                       nbnwma = 4
                       nbnoma(1:2) = 13
                       nbnoma(3:4) = 10
                       idtpma(1:2) = 24
                       idtpma(3:4) = 19
                   end if
               case ('PYRAM13')
                   if (zi(jtypma+macou-1).eq.14) then
                       nbnwma = 4
                       nbnoma(1:4) = 10
                       idtpma(1:4) = 19
                   else
                       nbnwma = 4
                       nbnoma(1) = 13
                       nbnoma(2:4) = 10
                       idtpma(1) = 24
                       idtpma(2:4) = 19
                   end if
               case default
           end select
   end select
            do incc= 0,nbnwma-1
                call jeveuo(jexnum(conloc,zi(jlimane+incc)),'L',jconloc)
                zi(jlimane+incc)=ind+incc
! ---------------------- NOM DE LA MAILLE
                if (nbnwma .eq. 1) then
                    call jenuno(jexnum(main//'.NOMMAI',inc),nomma)
                    call jecroc(jexnom(maout//'.NOMMAI',nomma))
                else
                    call codent(nma+ind1, 'G', knume)
                    if (knume(1:1)=='*') then
                        ASSERT(.false.)
                    endif
                    lgma = lxlgut(knume)
                    if (lgma+1 .gt. 8) then
                        call utmess('F', 'ALGELINE_16')
                    endif
                    nomma ='M'// knume(1:lgma)
                    call jecroc(jexnom(maout//'.NOMMAI',nomma))
                    ind1=ind1+1
                end if
! ----------------------- CONNECTIVITE MAILLE-PATCH
                if (ntrou .eq. 1) then
                    zi(jcnmpa+ind+incc-1)=zi(jlimane-1+nbnwma+1)
                endif
! ----------------------- NOUVELLES MAILLES
                zi(jtpmao+ind+incc-1)=  idtpma(incc+1)
                call jeecra(jexnum(maout//'.CONNEX',ind+incc),&
                            'LONMAX',nbnoma(incc+1))
                call jeveuo(jexnum(maout//'.CONNEX',ind+incc),&
                            'E', jcnmao)
                do inc2=1, nbnoma(incc+1)
                        zi(jcnmao+inc2-1)=zi(jconloc+inc2-1)
                end do
            end do
            ind=ind+nbnwma
        else
! --------------COPIE A L'IDENTIQUE
            zi(jtpmao+ind-1)=zi(jtypma+inc-1)
            call jenuno(jexnum(main//'.NOMMAI',inc),nomma)
            call jecroc(jexnom(maout//'.NOMMAI',nomma))
            call jeveuo(jexnum(main//'.CONNEX',inc), 'L', jcnmai)
            call jelira(jexnum(main//'.CONNEX',inc), 'LONMAX', aux)
            call jeecra(jexnum(maout//'.CONNEX',ind), 'LONMAX', aux)
            call jeveuo(jexnum(maout//'.CONNEX',ind), 'E',jcnmao)
            do incc = 1,aux
                zi(jcnmao+incc-1)=zi(jcnmai+incc-1)
            end do
            if (izone .ne. 1) then
                if  (zi(odcmpa+inc-1) .ne. 0) then
                    zi(jcnmpa+ind-1) = zi(odcmpa+inc-1)
                end if
            end if
            ind=ind+1
        endif
    end do
! ----------------------------------------------------------------------
!      MISE A JOUR DES GROUPES DE MAILLE
! ----------------------------------------------------------------------
  ntrou=0
  ntrou1=0
  gpptnn=maout//'.PTRNOMMAI      '
  call jedetr(maout//'.GROUPEMA')
  call jedetr(maout//'.PTRNOMMAI')
  call jelira(main//'.GROUPEMA','NUTIOC',aux)
  call jecreo(maout//'.PTRNOMMAI', 'G N K24')
  call jeecra(maout//'.PTRNOMMAI', 'NOMMAX', aux)
  call jecrec(maout//'.GROUPEMA','G V I', 'NO '//gpptnn, 'DISPERSE', 'VARIABLE', aux)
  do inc = 1,aux
    ind=1
    rgma='&&CPPAGN.RGMA'
    cnivax='&&CPPAGN.CNIVAX'
    call wkvect(rgma,'V V I',nbma,jrgma)
    call jenuno(jexnum(main//'.GROUPEMA',inc),nomma)
    call jeveuo(jexnum(main//'.GROUPEMA',inc),'L',jgma)
    call jelira(jexnum(main//'.GROUPEMA',inc),'LONUTI',lgma)
    call utlisi('INTER', lima, nbma, zi(jgma), lgma, zi(jrgma), nbma,&
                ntrou)
    call utlisi('INTER', zi(jgma), lgma, zi(jcninv), nbma, zi(jrgma), nbma,&
                 ntrou1)
    call jecroc(jexnom(maout//'.GROUPEMA',nomma))
        if (ntrou .gt. 0 .or. ntrou1 .gt. 0 ) then
! ----- DIMENSION DU NOUVEAU GROUPE_MA ------------------------------------------------------------
     nbnwma = 0
     call wkvect(cnivax,'V V I', nma, jcivax)
     call cnmpmc(main,lgma, zi(jgma),zi(jcivax))
     do incc =1, lgma
         macou = zi(jgma+incc-1)

         call utlisi('INTER',  zi(jgma+incc-1), 1,lima, nbma, res, 1,&
                     ntrou)
         call utlisi('INTER',  zi(jgma+incc-1), 1, zi(jcninv), nbma, res, 1,&
                     ntrou1)

         if (ntrou .eq. 1) then
             call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macou-1)), typmail_trait)
             select case (typmail_trait)
                 case ('SEG2')
                     call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+zi(jcivax+incc-1)-1)), typmail)
                     if (typmail.eq. 'TRIA3' ) then
                         nbnwma = nbnwma + 2
                     elseif (typmail.eq. 'QUAD4' ) then
                         nbnwma = nbnwma + 3
                     endif
                 case ('SEG3', 'QUAD9')
                     nbnwma = nbnwma + 1
                 case ('TRIA3', 'TRIA6')
                     nbnwma = nbnwma + 3
                 case ('QUAD4', 'QUAD8')
                     if (typ_dec.eq.0 .and.&
                         (zi(jtypma+zi(jcivax+incc-1)-1) .eq. 25.or.&
                          zi(jtypma+zi(jcivax+incc-1)-1) .eq. 26)) then
                         nbnwma = nbnwma + 5
                     else
                         nbnwma = nbnwma + 4
                     end if
                 case default
                     ASSERT(.false.)
             end select
         elseif (ntrou1 .eq. 1) then
             call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macou-1)), typmail_trait)
             select case (typmail_trait)
                 case ('TRIA3')
                     nbnwma = nbnwma + 2
                 case ('TRIA6', 'QUAD8', 'HEXA27')
                     nbnwma = nbnwma + 1
                 case ('QUAD4')
                     nbnwma = nbnwma + 4
                 case ('TETRA4', 'TETRA10')
                     nbnwma = nbnwma + 3
                 case ('HEXA8', 'HEXA20')
                     if (typ_dec.eq.0) then
                         nbnwma = nbnwma + 6
                     else
                         nbnwma = nbnwma + 5
                     end if
                 case ('PENTA6', 'PENTA15','PYRAM5', 'PYRAM13')
                     nbnwma = nbnwma + 4
                 case default
                     ASSERT(.false.)
             end select
         else
             nbnwma = nbnwma + 1
         end if
     end do
     call jeecra(jexnum(maout//'.GROUPEMA',inc),'LONUTI',&
                 nbnwma)
     call jeecra(jexnum(maout//'.GROUPEMA',inc),'LONMAX',&
                 nbnwma)
     call jeveuo(jexnum(maout//'.GROUPEMA',inc),'E',jgmao)
! ----- REMPLISSAGE NOUVEAU GROUPE_MAI ------------------------------------------------------------
  do incc =1, lgma
      macou = zi(jgma+incc-1)
      call utlisi('INTER',  zi(jgma+incc-1), 1,lima, nbma, res, 1,&
                  ntrou)
      call utlisi('INTER',  zi(jgma+incc-1), 1, zi(jcninv), nbma, res, 1,&
                  ntrou1)
      nbnwma = 1
      if (ntrou .eq. 1) then
          call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macou-1)), typmail_trait)
          select case (typmail_trait)
! NTROU : MAILLES DE PEAU
           case ('SEG2')
               call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+zi(jcivax+incc-1)-1)), typmail)
               if (typmail .eq. 'TRIA3' ) then
                   nbnwma = 2
               elseif (typmail .eq. 'QUAD4' ) then
                   nbnwma = 3
               endif
           case ('SEG3', 'QUAD9')
               nbnwma =  1
           case ('TRIA3', 'TRIA6')
               nbnwma = 3
           case ('QUAD4', 'QUAD8')
               if (typ_dec.eq.0 .and. &
                   (zi(jtypma+zi(jcivax+incc-1)-1) .eq. 25 .or.&
                    zi(jtypma+zi(jcivax+incc-1)-1) .eq. 26)) then
                   nbnwma =  5
               else
                   nbnwma =  4
               end if
           case default
               ASSERT(.false.)
     end select
    elseif (ntrou1 .eq. 1) then
        call jenuno(jexnum('&CATA.TM.NOMTM', zi(jtypma+macou-1)), typmail_trait)
        select case (typmail_trait)
! NTROU1 : MAILLES DE CORPS
            case ('TRIA3')
                nbnwma = 2
            case ('TRIA6', 'QUAD8', 'HEXA27')
                nbnwma =  1
            case ('QUAD4')
                nbnwma =  4
            case ('TETRA4', 'TETRA10')
                nbnwma = 3
            case ('HEXA8', 'HEXA20')
                if (typ_dec.eq.0) then
                   nbnwma =  6
               else
                   nbnwma =  5
               end if
           case ('PENTA6', 'PENTA15','PYRAM5','PYRAM13')
               nbnwma = 4
            case default
                ASSERT(.false.)
        end select
    endif
    if (nbnwma .gt. 1) then
    call jeveuo(jexnum(limane,macou),'L', jlimane)
        do ind1= 1, nbnwma
            zi(jgmao+ind-1+ind1-1)=zi(jlimane+ind1-1)
        end do
    ind=ind+nbnwma
    else
! ---------------------- RECOPIE A L'IDENTIQUE
                    call jenuno(jexnum(main//'.NOMMAI',zi(jgma+incc-1)),&
                                nomma)
                    call jenonu(jexnom(maout//'.NOMMAI',nomma),numa)
                    zi(jgmao+ind-1)=numa
                    ind=ind+1
                end if
            end do
        else
! ------ RECOPIE A L'IDENTIQUE
            call jeecra(jexnum(maout//'.GROUPEMA',inc),'LONUTI',lgma)
            call jeecra(jexnum(maout//'.GROUPEMA',inc),'LONMAX',lgma)
            call jeveuo(jexnum(maout//'.GROUPEMA',inc),'E',jgmao)
            do incc= 1, lgma
                call jenuno(jexnum(main//'.NOMMAI',zi(jgma+incc-1)),&
                            nomma)
                call jenonu(jexnom(maout//'.NOMMAI',nomma),numa)
                zi(jgmao+incc-1)=numa
            end do
        endif
        call jedetr(cnivax)
        call jedetr(rgma)
    end do
! ---------------------------------------------------------------------
!      DESTRUCTION DES VARIABLES AUXILIAIRES
! ---------------------------------------------------------------------
   call jedetr(limane)
   call jedetr(conloc)
   call jedetr(cninv)
   call jedema()
end subroutine
