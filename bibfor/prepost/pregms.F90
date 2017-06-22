! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine pregms(igmsh, imod)
! aslint: disable=
    implicit none
#include "jeveux.h"
#include "asterfort/gmeelt.h"
#include "asterfort/gmeneu.h"
#include "asterfort/gmlelt.h"
#include "asterfort/gmlneu.h"
#include "asterfort/inigms.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedetr.h"
#include "asterfort/jjmmaa.h"
#include "asterfort/utmess.h"
    integer :: igmsh, imod
!.======================================================================
!
!      PREGMS --   INTERFACE GMSH --> ASTER
!                  LECTURE DU FICHIER  .GMSH
!                  ECRITURE DU FICHIER .MAIL
!
!   ARGUMENT        E/S  TYPE         ROLE
!    IGMSH          IN    I         UNITE LOGIQUE DU FICHIER GMSH
!    IMOD           IN    I         UNITE LOGIQUE DU FICHIER MAIL
!
! ......................................................................
!
!
!
!
    character(len=4) :: ct(3)
    character(len=8) :: rquoi
    character(len=12) :: aut, debfic, finnod, debelm, debno
    character(len=14) :: aut1
    integer :: i, imes, nbmail, nbnode, versio, maxnod, nbtyma
    integer :: vali(1)
!
    parameter    (maxnod=32,nbtyma=19)
    integer :: nbnoma(nbtyma), nuconn(nbtyma, maxnod)
    character(len=8) :: nomail(nbtyma)
!
! ----------------------------------------------------------------------
!
! ---- INITIALISATIONS
!      ---------------
    rquoi = '????????'
!
    do 10 i = 1, nbtyma
        nomail(i) = rquoi
10  end do
!
! --- RECUPERATION DES NUMEROS D'UNITE LOGIQUE DES FICHIERS :
!     -----------------------------------------------------
    imes = iunifi('MESSAGE')
!
! --- AFFECTATION DE NOMAIL AVEC LE NOM DU TYPE DES ELEMENTS :
!     ------------------------------------------------------
    call inigms(nomail, nbnoma, nuconn)
!
! --- LECTURE EN DEBUT DU FICHIER .GMSH POUR DETERMINER LE FORMAT :
!     -----------------------------------------
    read(igmsh,*) debfic
!
    if (debfic(1:4) .eq. '$NOD') then
        versio = 1
    else if (debfic(1:11).eq.'$MeshFormat') then
        versio = 2
        read(igmsh,*)
        read(igmsh,*)
20      continue
        read(igmsh,*) debno
        if (debno(1:6) .ne. '$Nodes') then
            goto 20
        endif
    else
        call utmess('F', 'PREPOST6_38')
    endif
!
    call utmess('I', 'PREPOST6_39')
    vali(1)=versio
    call utmess('I', 'PREPOST6_40', si=vali(1))
!
! --- ECRITURE DU TITRE DANS LE FICHIER .MAIL :
!     ---------------------------------------
    write(imod,'(A)') 'TITRE'
!
! --- ECRITURE DE LA DATE DU JOUR :
!     ---------------------------
    call jjmmaa(ct, aut)
    aut1 = 'INTERFACE_GMSH'
    write(imod,'(9X,2A,17X,A,A2,A,A2,A,A4)')'AUTEUR=',aut1,'DATE=',&
     &  ct(1)(1:2),'/',ct(2)(1:2),'/',ct(3)
    write(imod,'(A)') 'FINSF'
    write(imod,'(A)') '%'
!
! --- LECTURE DES NOEUDS ET DE LEURS COORDONNEES DANS LE FICHIER .GMSH:
!     ----------------------------------------------------------------
    write(imes,*)
    write(imes,*) 'LECTURE DES NOEUDS ET DE LEURS COORDONNEES'
    call gmlneu(igmsh, nbnode)
!
! --- FIN DE LA LECTURE DES NOEUDS :
!     ----------------------------
    read(igmsh,*) finnod
!
    if ((finnod(1:7).ne.'$ENDNOD') .and. (finnod(1:9).ne.'$EndNodes')) then
        call utmess('F', 'PREPOST6_41')
    endif
!
! --- DEBUT DE LA LECTURE DES ELEMENTS DANS LE FICHIER .GMSH :
!     ------------------------------------------------------
    write(imes,*)
    write(imes,*) 'LECTURE DES MAILLES'
    read(igmsh,*) debelm
!
    if ((debelm(1:4).ne.'$ELM') .and. (debelm(1:9).ne.'$Elements')) then
        call utmess('F', 'PREPOST6_42')
    endif
!
!
! --- LECTURE DES MAILLES ET DES GROUP_MA :
!     -----------------------------------
    call gmlelt(igmsh, maxnod, nbtyma, nbmail, nbnoma,&
                nuconn, versio)
!
! --- ECRITURE DES NOEUDS ET DE LEURS COORDONNEES DANS LE FICHIER .MAIL:
!     -----------------------------------------------------------------
    call gmeneu(imod, nbnode)
!
! --- ECRITURE DES MAILLES ET DES GROUP_MA DANS LE FICHIER .MAIL :
!     ----------------------------------------------------------
    call gmeelt(imod, nbtyma, nomail, nbnoma, nuconn,&
                nbmail)
!
! --- MENAGE :
!     ------
    call jedetr('&&PREGMS.INFO.NOEUDS')
    call jedetr('&&PREGMS.COOR.NOEUDS')
    call jedetr('&&PREGMS.NUMERO.MAILLES')
    call jedetr('&&PREGMS.TYPE.MAILLES')
    call jedetr('&&PREGMS.GROUPE.MAILLES')
    call jedetr('&&PREGMS.NBNO.MAILLES')
    call jedetr('&&PREGMS.CONNEC.MAILLES')
    call jedetr('&&PREGMS.NBMA.GROUP_MA')
    call jedetr('&&PREGMS.NBTYP.MAILLES')
    call jedetr('&&PREGMS.LISTE.GROUP_MA')
    call jedetr('&&PREGMS.INDICE.GROUP_MA')
    call jedetr('&&PREGMS.GRMA.MAILLES')
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
