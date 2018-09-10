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

subroutine pjefco(moa1, moa2, corres, base)
    implicit none
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!     COMMANDE:  PROJ_CHAMP  METHODE:'ELEM'
! BUT : CALCULER LA STRUCTURE DE DONNEE CORRESP_2_MAILLA
! ----------------------------------------------------------------------
!
!
! 0.1. ==> ARGUMENTS
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/r8maem.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/pj2dco.h"
#include "asterfort/pj3dco.h"
#include "asterfort/pj4dco.h"
#include "asterfort/pj6dco.h"
#include "asterfort/pjefca.h"
#include "asterfort/pjeftg.h"
#include "asterfort/pjfuco.h"
#include "asterfort/pjreco.h"
#include "asterfort/pjxxu2.h"
#include "asterfort/reliem.h"
#include "asterfort/utlisi.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: moa1, moa2
    character(len=16) :: corres
    character(len=1) :: base
!
! 0.2. ==> COMMUNS
!
!
!
! 0.3. ==> VARIABLES LOCALES
!
!
    character(len=8) :: noma1, noma2, nomo1, nomo2, ncas
    character(len=16) :: corre1, corre2, corre3
    character(len=16) :: tymocl(5), motcle(5), nameListInterc
    character(len=24) :: geom2, geom1
    character(len=2) :: dim
    integer :: n1, nbocc, iocc, nbno2, nbma1, nbma2
    integer :: iexi, nbNodeInterc, nbnoma2, nbnono2
!
    aster_logical :: l_dmax, dbg, final_occ
    real(kind=8) :: dmax, dala
    integer, pointer :: limanu1(:) => null()
    integer, pointer :: linonu2(:) => null()
    integer, pointer :: limanu2(:) => null()
    integer, pointer :: linotmp(:) => null()
    integer, pointer :: linotm2(:) => null()
!----------------------------------------------------------------------
    call jemarq()
    ASSERT(base.eq.'V')
!
    corre1 = '&&PJEFCO.CORRES1'
    corre2 = '&&PJEFCO.CORRES2'
    corre3 = '&&PJEFCO.CORRES3'
!
    call jeexin(moa1//'.MODELE    .REPE', iexi)
    if (iexi .gt. 0) then
        nomo1=moa1
        call dismoi('NOM_MAILLA', nomo1, 'MODELE', repk=noma1)
    else
        nomo1=' '
        noma1=moa1
    endif
!
    call jeexin(moa2//'.MODELE    .REPE', iexi)
    if (iexi .gt. 0) then
        nomo2=moa2
        call dismoi('NOM_MAILLA', nomo2, 'MODELE', repk=noma2)
    else
        nomo2=' '
        noma2=moa2
    endif
!
!
!   Determination de dmax et l_dmax:
!   --------------------------------------------------------
    dmax=0.d0
    call getvr8(' ', 'DISTANCE_MAX', scal=dmax, nbret=n1)
    l_dmax=n1.eq.1
    call getvr8(' ', 'DISTANCE_ALARME', scal=dala, nbret=n1)
    if (n1.eq.0) dala=-1.d0
!
!
    call getfac('VIS_A_VIS', nbocc)
    if (nbocc .eq. 0) then
!        -- CAS : TOUT:'OUI'
!        ------------------------
        call pjefca(moa1, ' ', 0, ncas)
!
!        PRISE EN COMPTE DU MOT-CLE TRANSF_GEOM_[1|2]
!        --------------------------------------------
        call pjeftg(1, geom1, noma1, ' ', 1)
        call pjeftg(2, geom2, noma2, ' ', 1)
!
!
!
        dbg=.false.
        if (dbg) then
!          -- pour debug : on copie les 2 maillages sous les noms
!          'XXXMA1' et 'XXXMA2' sur la base globale
!          ce qui permet de les visualiser avec Salome.
!          Il faut faire :
!             XXXMA1=LIRE_MAILLAGE() # bidon
!             XXXMA2=LIRE_MAILLAGE() # bidon
!             U2=PROJ_CHAMP(...)
!             IMPR_RRESU(RESU=_F(MAILLAGE=XXXMA1))
!             IMPR_RRESU(RESU=_F(MAILLAGE=XXXMA2))
!
            call detrsd('MAILLAGE', 'XXXMA1')
            call detrsd('MAILLAGE', 'XXXMA2')
            call copisd('MAILLAGE', 'G', noma1, 'XXXMA1')
            call copisd('MAILLAGE', 'G', noma2, 'XXXMA2')
        endif
!
!
        if (ncas .eq. '2D') then
            call pj2dco('TOUT', moa1, moa2, 0, [0],&
                        0, [0], geom1, geom2, corres,&
                        l_dmax, dmax, dala)
        else if (ncas.eq.'3D') then
            call pj3dco('TOUT', moa1, moa2, 0, [0],&
                        0, [0], geom1, geom2, corres,&
                        l_dmax, dmax, dala)
        else if (ncas.eq.'2.5D') then
            call pj4dco('TOUT', moa1, moa2, 0, [0],&
                        0, [0], geom1, geom2, corres,&
                        l_dmax, dmax, dala)
        else if (ncas.eq.'1.5D') then
            call pj6dco('TOUT', moa1, moa2, 0, [0],&
                        0, [0], geom1, geom2, corres,&
                        l_dmax, dmax, dala)
        else
            ASSERT(.false.)
        endif
!
    else
!
!        -- CAS : VIS_A_VIS
!        ------------------------
!
!       -- le mot cle VIS_A_VIS ne peut pas fonctionner avec la methode ECLA_PG :
        if (noma1(1:2) .eq. '&&') then
            call utmess('F', 'CALCULEL4_17')
        endif
!
        do iocc = 1, nbocc
           final_occ = .false.
           if (iocc.eq. nbocc) final_occ = .true.
!
!           -- RECUPERATION DE LA LISTE DE MAILLES LMA1 :
!           ----------------------------------------------
            motcle(1) = 'MAILLE_1'
            tymocl(1) = 'MAILLE'
            motcle(2) = 'GROUP_MA_1'
            tymocl(2) = 'GROUP_MA'
            motcle(3) = 'TOUT_1'
            tymocl(3) = 'TOUT'
!
!
!
            call reliem(nomo1, noma1, 'NU_MAILLE', 'VIS_A_VIS', iocc,&
                        3, motcle, tymocl, '&&PJEFCO.LIMANU1', nbma1)
            call jeveuo('&&PJEFCO.LIMANU1', 'L', vi=limanu1)
            
!
!           -- SI PRESENT : RECUPERATION DE LA LISTE DE MAILLE LMA2 
!              POUR VERIFICATION :
!           --------------------------------------------------------
            motcle(1) = 'MAILLE_2'
            tymocl(1) = 'MAILLE'
            motcle(2) = 'GROUP_MA_2'
            tymocl(2) = 'GROUP_MA'
            motcle(3) = 'TOUT_2'
            tymocl(3) = 'TOUT'
            call reliem(' ', noma2, 'NU_MAILLE', 'VIS_A_VIS', iocc,&
                        3, motcle, tymocl, '&&PJEFCO.LIMANU2', nbma2)
            
            nbnoma2 = 0
            if (nbma2 .gt. 0) then
                call jeveuo('&&PJEFCO.LIMANU2', 'L', vi=limanu2)
                call pjefca(moa2, '&&PJEFCO.LIMANU2', -iocc, ncas)
                
                if (ncas .eq. '2D') then
                    dim = '2D'
                else if (ncas.eq.'3D') then
                    dim='3D'
                else if (ncas.eq.'2.5D') then
                    dim='2D'
                else if (ncas.eq.'1.5D') then
                    dim='1D'
                else
                    ASSERT(.false.)
                endif

                call pjxxu2(dim, moa2, limanu2, nbma2, '&&PJEFCO.LINOTMP',&
                            nbnoma2)
                call jedetr('&&PJEFCO.LIMANU2')
            endif
!
!           -- RECUPERATION DE LA LISTE DE NOEUDS LNO2 :
!           ----------------------------------------------
            motcle(1) = 'NOEUD_2'
            tymocl(1) = 'NOEUD'
            motcle(2) = 'GROUP_NO_2'
            tymocl(2) = 'GROUP_NO'

            call reliem(' ', noma2, 'NU_NOEUD', 'VIS_A_VIS', iocc,&
                        2, motcle, tymocl, '&&PJEFCO.LINOTM2', nbnono2)
            
            call wkvect('&&PJEFCO.LINONU2', 'V V I', nbnono2+nbnoma2, vi=linonu2)
            
            if (nbnono2.gt.0 .and. nbnoma2.eq.0) then
                call jeveuo('&&PJEFCO.LINOTM2', 'L', vi=linotm2)
                nbno2 = nbnono2
                linonu2(1:nbno2) = linotm2(1:nbno2)
                call jedetr('&&PJEFCO.LINOTM2')
            elseif (nbnono2.eq.0 .and. nbnoma2.gt.0) then
                call jeveuo('&&PJEFCO.LINOTMP', 'L', vi=linotmp)
                nbno2 = nbnoma2
                linonu2(1:nbno2) = linotmp(1:nbno2)
                call jedetr('&&PJEFCO.LINOTMP')
            elseif (nbnono2.gt.0 .and. nbnoma2.gt.0)then
                call jeveuo('&&PJEFCO.LINOTM2', 'L', vi=linotm2)
                call jeveuo('&&PJEFCO.LINOTMP', 'L', vi=linotmp)
                call utlisi('UNION', linotm2, nbnono2, linotmp, nbnoma2,&
                            linonu2, nbnono2+nbnoma2, nbno2)
                ASSERT(nbno2.gt.0)
                call jedetr('&&PJEFCO.LINOTM2')
                call jedetr('&&PJEFCO.LINOTMP')
            else
                ASSERT(.false.)
            endif
! 
!
!           intersection entre les noeuds2 des occurrences precedentes
!           et de l'occurrence courante
            call pjreco(linonu2, nbno2, iocc, final_occ, nameListInterc,&
                        nbNodeInterc)
!
!           PRISE EN COMPTE DU MOT-CLE TRANSF_GEOM_[1|2]
!           --------------------------------------------
            call pjeftg(1, geom1, noma1, 'VIS_A_VIS', iocc)
            call pjeftg(2, geom2, noma2, 'VIS_A_VIS', iocc)
!
!           -- CALCUL DU CORRESP_2_MAILLA POUR IOCC :
!           ----------------------------------------------
            call pjefca(moa1, '&&PJEFCO.LIMANU1', iocc, ncas)
!
            call detrsd('CORRESP_2_MAILLA', corre1)
            if (ncas .eq. '2D') then
                call pj2dco('PARTIE', moa1, moa2, nbma1, limanu1,&
                            nbno2, linonu2, geom1, geom2, corre1,&
                            l_dmax, dmax, dala, listIntercz = nameListInterc,& 
                            nbIntercz = nbNodeInterc)
            else if (ncas.eq.'3D') then
                call pj3dco('PARTIE', moa1, moa2, nbma1, limanu1,&
                            nbno2, linonu2, geom1, geom2, corre1,&
                            l_dmax, dmax, dala, listIntercz = nameListInterc,& 
                            nbIntercz = nbNodeInterc)
            else if (ncas.eq.'2.5D') then
                call pj4dco('PARTIE', moa1, moa2, nbma1, limanu1,&
                            nbno2, linonu2, geom1, geom2, corre1,&
                            l_dmax, dmax, dala, listIntercz = nameListInterc,& 
                            nbIntercz = nbNodeInterc)
            else if (ncas.eq.'1.5D') then
                call pj6dco('PARTIE', moa1, moa2, nbma1, limanu1,&
                            nbno2, linonu2, geom1, geom2, corre1,&
                            l_dmax, dmax, dala, listIntercz = nameListInterc,& 
                            nbIntercz = nbNodeInterc)
            else
                ASSERT(.false.)
            endif
            if (final_occ) call jedetr(nameListInterc)
!
!
!           -- SURCHARGE DU CORRESP_2_MAILLA :
!           ----------------------------------------------
            if (iocc .eq. 1) then
                call copisd('CORRESP_2_MAILLA', 'V', corre1, corre2)
            else
                call pjfuco(corre2, corre1, 'V', corre3)
                call detrsd('CORRESP_2_MAILLA', corre2)
                call copisd('CORRESP_2_MAILLA', 'V', corre3, corre2)
                call detrsd('CORRESP_2_MAILLA', corre3)
            endif
!
            call jedetr('&&PJEFCO.LIMANU1')
            call jedetr('&&PJEFCO.LINONU2')
        end do
        call copisd('CORRESP_2_MAILLA', 'V', corre2, corres)
        call detrsd('CORRESP_2_MAILLA', corre1)
        call detrsd('CORRESP_2_MAILLA', corre2)
    endif
!
!
    call jedema()
end subroutine
