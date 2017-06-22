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

subroutine precou(imod, typema)
! person_in_charge: nicolas.greffet at edf.fr
!.======================================================================
    implicit none
#include "jeveux.h"
#include "asterfort/coeelt.h"
#include "asterfort/coeneu.h"
#include "asterfort/colelt.h"
#include "asterfort/colneu.h"
#include "asterfort/inigms.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jjmmaa.h"
    integer :: imod
    character(len=8) :: typema
!
!      PRECOU --   INTERFACE COUPLAGE --> ASTER
!                  LECTURE DU MAILLAGE .COUP PAR RECEPTION MEMOIRE
!                  ECRITURE DU FICHIER .MAIL
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  VARIABLES LOCALES
!      PARAMETER (MAXNOD=32, NBTYMA=15)
    integer :: maxnod, nbtyma, i, nbnode, nbmail
    parameter    (maxnod=32,nbtyma=19)
    integer :: nbnoma(nbtyma), nuconn(nbtyma, maxnod), imes
    character(len=4) :: ct(3)
    character(len=8) :: nomail(nbtyma), rquoi
    character(len=12) :: aut
    character(len=14) :: aut1
!
!
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! ---- INITIALISATIONS
!      ---------------
    call jemarq()
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
! --- ECRITURE DU TITRE DANS LE FICHIER .MAIL :
!     ---------------------------------------
    write(imod,'(A)') 'TITRE'
!
! --- ECRITURE DE LA DATE DU JOUR :
!     ---------------------------
    call jjmmaa(ct, aut)
    aut1 = 'INTERFACE_YACS'
    write(imod,'(9X,2A,17X,A,A2,A,A2,A,A4)')'AUTEUR=',aut1,'DATE=',&
     &  ct(1)(1:2),'/',ct(2)(1:2),'/',ct(3)
    write(imod,'(A)') 'FINSF'
    write(imod,'(A)') '%'
    write(imes,*) 'ECRITURE DU TITRE'
!
! --- LECTURE DES NOEUDS ET DE LEURS COORDONNEES PAR RECEPTION MEMOIRE :
!     ------------------------------------------------------------------
    call colneu(nbnode, typema)
!
! --- LECTURE DES MAILLES ET DES GROUP_MA :
!     -----------------------------------
!FH
!=>
!      CALL COLELT(NBNODE, JGROMA, MAXNOD,NBTYMA,NBMAIL,NBNOMA,NUCONN)
    call colelt(nbnode, maxnod, nbtyma, nbmail, nbnoma,&
                nuconn)
!<=
!FH
!
! --- ECRITURE DES NOEUDS ET DE LEURS COORDONNEES DANS LE FICHIER .MAIL:
!     -----------------------------------------------------------------
    call coeneu(imod, nbnode)
!
! --- ECRITURE DES MAILLES ET DES GROUP_MA DANS LE FICHIER .MAIL :
!     ----------------------------------------------------------
    call coeelt(imod, nbtyma, nomail, nbnoma, nuconn,&
                nbmail)
!
! --- MENAGE :
!     ------
    call jedetr('&&PRECOU.INFO.NOEUDS')
    call jedetr('&&PRECOU.COOR.NOEUDS')
    call jedetr('&&PRECOU.NUMERO.MAILLES')
    call jedetr('&&PRECOU.TYPE.MAILLES')
    call jedetr('&&PRECOU.GROUPE.MAILLES')
    call jedetr('&&PRECOU.NBNO.MAILLES')
    call jedetr('&&PRECOU.CONNEC.MAILLES')
    call jedetr('&&PRECOU.NBMA.GROUP_MA')
    call jedetr('&&PRECOU.NBTYP.MAILLES')
    call jedetr('&&PRECOU.LISTE.GROUP_MA')
    call jedetr('&&PRECOU.INDICE.GROUP_MA')
    call jedetr('&&PRECOU.GRMA.MAILLES')
!
!.============================ FIN DE LA ROUTINE ======================
    call jedema()
end subroutine
